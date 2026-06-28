#!/usr/bin/env python3
from __future__ import annotations

import json
import os
import re
import shlex
import sqlite3
import subprocess
import threading
import uuid
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from dotenv import load_dotenv
from slack_bolt import App
from slack_bolt.adapter.socket_mode import SocketModeHandler

"""
Slack Coding Agent Relay.

This module runs a Slack Socket Mode bot that connects Slack threads to
project-specific Claude Code sessions.

High-level flow:

1. A Slack message arrives.
   - Identify `channel_id`.
   - Identify `thread_ts`.
     - For a top-level message, use the message `ts`.
     - For a thread reply, use Slack's `thread_ts`.
   - Parse the message text.
   - Load static project config from `projects.json`.
   - Load runtime thread state from the in-memory `THREAD_STATE` dictionary.

2. If the message selects a project, such as:
      @project halo
      start a thread for halo

   The bot:
   - validates that the project exists in `projects.json`
   - validates that the project `host_dir` exists
   - generates a Claude session UUID
   - stores this Slack thread's project/session mapping in `THREAD_STATE`
   - replies in the Slack thread with the selected project and session info

3. If the message is inside a known Slack thread, such as:
    build it
    fix the error
    run the test again

   The bot:
   - looks up the project/session from `THREAD_STATE`
   - loads the project config from `projects.json`
   - builds a Claude prompt from the Slack text and project context
   - runs Claude in the project directory, or inside the configured Docker container
   - uses `claude -p --session-id <SESSION_ID>` for the first call
   - uses `claude -p --resume <SESSION_ID>` for follow-up calls
   - posts Claude's result back to the same Slack thread

4. If Docker or Claude fails:
   - the bot keeps the Slack thread assigned to the same project
   - clears/replaces the stale Claude session ID
   - asks the user to send the next message to start fresh

Thread state is persisted to SQLite so it survives bot restarts.
"""

load_dotenv()

SLACK_BOT_TOKEN = os.environ["SLACK_BOT_TOKEN"]
SLACK_APP_TOKEN = os.environ["SLACK_APP_TOKEN"]

BASE_DIR = Path(__file__).resolve().parent
PROJECTS_JSON = Path(os.environ.get("PROJECTS_JSON", BASE_DIR / "projects.json")).expanduser()
DB_PATH = Path(os.environ.get("STATE_DB", BASE_DIR / "thread_state.db"))

ALLOWED_USER_IDS = {
    user_id.strip()
    for user_id in os.environ.get("ALLOWED_USER_IDS", "").split(",")
    if user_id.strip()
}

# Runtime thread state — loaded from SQLite at startup and kept in sync.
# Key: (channel_id, thread_ts)
# Value: {"project_key": str, "claude_session_id": str, "started": bool}
THREAD_STATE: dict[tuple[str, str], dict[str, Any]] = {}
THREAD_LOCKS: dict[tuple[str, str], threading.Lock] = {}
THREAD_LOCKS_GUARD = threading.Lock()

# Project starter commands.
# Supports:
#   @project halo
#   start a thread for halo
#   open a thread for halo
#   create a thread for halo
PROJECT_PATTERNS = [
    re.compile(r"^\s*@project\s+([a-zA-Z0-9_-]+)\s*$", re.IGNORECASE),
    re.compile(
        r"\b(?:start|open|create)\s+(?:a\s+)?thread\s+for\s+([a-zA-Z0-9_-]+)\b",
        re.IGNORECASE,
    ),
]

app = App(token=SLACK_BOT_TOKEN)


@dataclass(frozen=True)
class Project:
    key: str
    name: str
    host_dir: Path
    container: str | None
    container_dir: str | None


# ---------------------------------------------------------------------------
# SQLite persistence
# ---------------------------------------------------------------------------

def _db_connect() -> sqlite3.Connection:
    return sqlite3.connect(DB_PATH)


def init_db() -> None:
    with _db_connect() as conn:
        conn.execute("""
            CREATE TABLE IF NOT EXISTS thread_state (
                channel_id        TEXT NOT NULL,
                thread_ts         TEXT NOT NULL,
                project_key       TEXT NOT NULL,
                claude_session_id TEXT NOT NULL,
                started           INTEGER NOT NULL DEFAULT 0,
                PRIMARY KEY (channel_id, thread_ts)
            )
        """)

    with _db_connect() as conn:
        rows = conn.execute(
            "SELECT channel_id, thread_ts, project_key, claude_session_id, started FROM thread_state"
        ).fetchall()

    for row in rows:
        key = (row[0], row[1])
        THREAD_STATE[key] = {
            "project_key": row[2],
            "claude_session_id": row[3],
            "started": bool(row[4]),
        }

    print(f"[db] Loaded {len(THREAD_STATE)} thread(s) from {DB_PATH}", flush=True)


def _db_upsert(key: tuple[str, str], state: dict[str, Any]) -> None:
    with _db_connect() as conn:
        conn.execute(
            """
            INSERT OR REPLACE INTO thread_state
                (channel_id, thread_ts, project_key, claude_session_id, started)
            VALUES (?, ?, ?, ?, ?)
            """,
            (key[0], key[1], state["project_key"], state["claude_session_id"], int(state.get("started", False))),
        )


def _db_delete(key: tuple[str, str]) -> None:
    with _db_connect() as conn:
        conn.execute(
            "DELETE FROM thread_state WHERE channel_id = ? AND thread_ts = ?",
            key,
        )


# ---------------------------------------------------------------------------
# Project loading
# ---------------------------------------------------------------------------

def load_projects() -> dict[str, Project]:
    if not PROJECTS_JSON.is_file():
        raise FileNotFoundError(f"projects.json not found: {PROJECTS_JSON}")

    with PROJECTS_JSON.open("r", encoding="utf-8") as f:
        raw = json.load(f)

    projects_raw = raw.get("projects")
    if not isinstance(projects_raw, dict):
        raise ValueError("projects.json must contain a top-level object named 'projects'")

    projects: dict[str, Project] = {}

    for key, cfg in projects_raw.items():
        if not isinstance(cfg, dict):
            raise ValueError(f"Project {key!r} must be a JSON object")

        host_dir_raw = cfg.get("host_dir")
        if not host_dir_raw:
            raise ValueError(f"Project {key!r} is missing required field: host_dir")

        host_dir = Path(str(host_dir_raw)).expanduser()

        projects[key] = Project(
            key=key,
            name=str(cfg.get("name") or key),
            host_dir=host_dir,
            container=cfg.get("container"),
            container_dir=cfg.get("container_dir"),
        )

    return projects


def validate_project(project_key: str) -> Project:
    projects = load_projects()

    if project_key not in projects:
        known = ", ".join(sorted(projects.keys())) or "(none)"
        raise ValueError(f"Unknown project `{project_key}`. Known projects: {known}")

    project = projects[project_key]

    if not project.host_dir.is_dir():
        raise ValueError(f"Project host_dir does not exist: {project.host_dir}")

    if project.container and not project.container_dir:
        raise ValueError(f"Project `{project_key}` has a container but no container_dir")

    return project


# ---------------------------------------------------------------------------
# Thread state helpers
# ---------------------------------------------------------------------------

def get_thread_key(event: dict[str, Any]) -> tuple[str, str]:
    channel_id = event["channel"]
    thread_ts = event.get("thread_ts") or event["ts"]
    return channel_id, thread_ts


def get_thread_lock(key: tuple[str, str]) -> threading.Lock:
    with THREAD_LOCKS_GUARD:
        if key not in THREAD_LOCKS:
            THREAD_LOCKS[key] = threading.Lock()
        return THREAD_LOCKS[key]


def user_is_allowed(event: dict[str, Any]) -> bool:
    if not ALLOWED_USER_IDS:
        return True
    return event.get("user") in ALLOWED_USER_IDS


def clean_slack_text(text: str) -> str:
    """Remove common Slack mention/link markup enough for simple command parsing."""
    text = re.sub(r"<@[A-Z0-9]+>", "", text)
    text = text.replace("&lt;", "<").replace("&gt;", ">").replace("&amp;", "&")
    return text.strip()


def extract_project_key(text: str) -> str | None:
    text = clean_slack_text(text)

    for pattern in PROJECT_PATTERNS:
        match = pattern.search(text)
        if match:
            return match.group(1).lower()

    return None


def start_or_replace_thread_state(key: tuple[str, str], project_key: str) -> dict[str, Any]:
    state: dict[str, Any] = {
        "project_key": project_key,
        "claude_session_id": str(uuid.uuid4()),
        "started": False,
    }
    THREAD_STATE[key] = state
    _db_upsert(key, state)
    return state


def reset_claude_session(key: tuple[str, str]) -> str | None:
    state = THREAD_STATE.get(key)
    if not state:
        return None

    state["claude_session_id"] = str(uuid.uuid4())
    state["started"] = False
    _db_upsert(key, state)
    return state["claude_session_id"]


def forget_thread(key: tuple[str, str]) -> bool:
    existed = key in THREAD_STATE
    THREAD_STATE.pop(key, None)
    _db_delete(key)
    return existed


# ---------------------------------------------------------------------------
# Formatting / Claude helpers
# ---------------------------------------------------------------------------

def format_project_status(project: Project, state: dict[str, Any]) -> str:
    started = bool(state.get("started"))
    session_id = state.get("claude_session_id") or "(none)"

    return (
        f"Project: `{project.key}`\n"
        f"Host dir: `{project.host_dir}`\n"
        f"Container: `{project.container or 'none'}`\n"
        f"Container dir: `{project.container_dir or 'none'}`\n"
        f"Claude session started: `{started}`\n"
        f"Claude session ID: `{session_id}`"
    )


def build_prompt(project: Project, user_text: str) -> str:
    return f"""
You are working on project: {project.key}.

Project host directory:
  {project.host_dir}

Container:
  {project.container or "none"}

Container working directory:
  {project.container_dir or "none"}

User message from Slack:
  {user_text}

Use the project CLAUDE.md and .claude/ instructions.
Do the requested work.
Summarize what you changed and what commands you ran.
""".strip()


def parse_claude_output(stdout: str) -> str:
    """
    Claude print mode with --output-format json may return JSON.
    Keep this robust because output formats can vary by version.
    """
    text = stdout.strip()
    if not text:
        return "(Claude returned no output.)"

    try:
        data = json.loads(text)
    except json.JSONDecodeError:
        return text

    # Common possibilities. Keep raw JSON fallback for debugging.
    for key in ("result", "message", "content", "text", "response"):
        value = data.get(key)
        if isinstance(value, str) and value.strip():
            return value.strip()

    return json.dumps(data, indent=2, ensure_ascii=False)


def build_claude_args(prompt: str, session_id: str, started: bool) -> list[str]:
    args = ["claude", "-p", "--output-format", "json"]

    if started:
        args += ["--resume", session_id]
    else:
        args += ["--session-id", session_id]

    args.append(prompt)
    return args


def run_claude(project: Project, prompt: str, session_id: str, started: bool) -> tuple[bool, str]:
    claude_args = build_claude_args(prompt, session_id, started)

    if project.container:
        assert project.container_dir is not None

        # Use shlex.join so Slack text is safely quoted inside bash -lc.
        shell_command = shlex.join(claude_args)

        cmd = [
            "docker",
            "exec",
            "-w",
            project.container_dir,
            project.container,
            "bash",
            "-lc",
            shell_command,
        ]

        result = subprocess.run(
            cmd,
            text=True,
            capture_output=True,
            timeout=1800,
            check=False,
        )
    else:
        result = subprocess.run(
            claude_args,
            cwd=project.host_dir,
            text=True,
            capture_output=True,
            timeout=1800,
            check=False,
        )

    if result.returncode != 0:
        error_text = (result.stderr or result.stdout or "").strip()
        return False, error_text or f"Claude command failed with exit code {result.returncode}"

    return True, parse_claude_output(result.stdout)


def chunk_for_slack(text: str, limit: int = 3500) -> list[str]:
    """Slack messages have limits. Use small chunks to be safe."""
    if len(text) <= limit:
        return [text]

    chunks: list[str] = []
    remaining = text

    while remaining:
        chunks.append(remaining[:limit])
        remaining = remaining[limit:]

    return chunks


def say_long(say, text: str, thread_ts: str | None = None) -> None:
    for chunk in chunk_for_slack(text):
        say(text=chunk, thread_ts=thread_ts)


# ---------------------------------------------------------------------------
# Slack event handler
# ---------------------------------------------------------------------------

@app.event("message")
def handle_message(event, say) -> None:
    # Ignore bot messages, edits, joins, etc.
    if event.get("subtype") is not None:
        return

    if not user_is_allowed(event):
        return

    raw_text = event.get("text", "")
    text = clean_slack_text(raw_text)

    if not text:
        return

    key = get_thread_key(event)
    channel_id, thread_ts = key
    print(f"[msg] key={key} has_thread_ts={'thread_ts' in event} known={key in THREAD_STATE} text={text[:60]!r}", flush=True)

    # 1. Project/thread initializer.
    project_key = extract_project_key(text)
    if project_key:
        try:
            project = validate_project(project_key)
        except Exception as exc:
            say(text=f"Could not start project thread: {exc}", thread_ts=thread_ts)
            return

        state = start_or_replace_thread_state(key, project_key)

        say(
            text=(
                f"Started a Claude session thread for `{project.key}`.\n\n"
                f"Project path: `{project.host_dir}`\n"
                f"Container: `{project.container or 'none'}`\n"
                f"Claude session ID: `{state['claude_session_id']}`\n\n"
                "Reply in this thread with normal messages like:\n"
                "`build it`, `fix the error`, `run the test again`, "
                "`what project is this`, or `reset this Claude session`."
            ),
            thread_ts=thread_ts,
        )
        return

    # 2. Ignore top-level messages that are not project initializers.
    if "thread_ts" not in event and key not in THREAD_STATE:
        return

    # 3. Thread-local command handling.
    state = THREAD_STATE.get(key)
    if not state:
        # Thread reply for a thread the bot no longer knows about.
        say(
            text=(
                "This thread is no longer tracked (the bot may have restarted).\n"
                "Send `@project <name>` to start a new session."
            ),
            thread_ts=thread_ts,
        )
        return

    try:
        project = validate_project(state["project_key"])
    except Exception as exc:
        say(text=f"Thread state is invalid: {exc}", thread_ts=thread_ts)
        return

    lowered = text.lower().strip()

    if lowered in {"what project is this", "where", "status"}:
        say(text=format_project_status(project, state), thread_ts=thread_ts)
        return

    if lowered in {"reset this claude session", "reset claude session", "reset session"}:
        new_session_id = reset_claude_session(key)
        say(
            text=(
                "Reset Claude session for this thread.\n"
                f"Project is still `{project.key}`.\n"
                f"New session ID: `{new_session_id}`"
            ),
            thread_ts=thread_ts,
        )
        return

    if lowered in {"forget this project", "forget project", "forget"}:
        forget_thread(key)
        say(text="Forgot the project/session mapping for this Slack thread.", thread_ts=thread_ts)
        return

    # 4. Route normal thread text to Claude.
    lock = get_thread_lock(key)
    if not lock.acquire(blocking=False):
        say(
            text="Claude is still working in this thread. Wait for the current run to finish, then send the next message.",
            thread_ts=thread_ts,
        )
        return

    try:
        session_id = state["claude_session_id"]
        started = bool(state.get("started", False))
        prompt = build_prompt(project, text)

        say(
            text=f"Running Claude for `{project.key}`...",
            thread_ts=thread_ts,
        )

        ok, output = run_claude(
            project=project,
            prompt=prompt,
            session_id=session_id,
            started=started,
        )

        if not ok:
            new_session_id = reset_claude_session(key)
            say(
                text=(
                    "The container or Claude session failed.\n"
                    f"This thread is still using project `{project.key}`.\n"
                    "I cleared the old Claude session. Send the next message and I will start fresh.\n\n"
                    f"New session ID: `{new_session_id}`\n\n"
                    f"Error:\n```{output[:2500]}```"
                ),
                thread_ts=thread_ts,
            )
            return

        state["started"] = True
        _db_upsert(key, state)
        say_long(say, output, thread_ts=thread_ts)

    finally:
        lock.release()


if __name__ == "__main__":
    print(f"Using projects.json: {PROJECTS_JSON}")
    print(f"Using state DB: {DB_PATH}")
    init_db()
    print("Starting Slack agent relay...")
    SocketModeHandler(app, SLACK_APP_TOKEN).start()
