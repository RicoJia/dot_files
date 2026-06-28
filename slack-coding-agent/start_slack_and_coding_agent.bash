#!/usr/bin/env bash 
set -euo pipefail

# This is an indempotent script 
# 1. Install/start Tailscale only if needed.
# 2. Ask you to log in to Tailscale only if the laptop is not authenticated.
# 3. Install Claude Code only if claude is missing.
# 4. Create/use your Python venv.
# 5. Start bot.py.

# -----------------------------
# 1. Start Tailscale
# -----------------------------

# Dir containing this script.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"

# Default project dir is the script dir.
# Override by running:
#   PROJECT_DIR=/path/to/project ./start_slack_and_coding_agent.bash
PROJECT_DIR="${PROJECT_DIR:-$SCRIPT_DIR}"

BOT_PY="${BOT_PY:-$PROJECT_DIR/slack_agent_relay.py}"
VENV_DIR="${VENV_DIR:-$PROJECT_DIR/.venv}"

echo "== Slack coding agent startup =="
echo "Script dir:  $SCRIPT_DIR"
echo "Project dir: $PROJECT_DIR"
echo "Bot file:    $BOT_PY"
echo

echo "Starting tailscaled..."
if ! systemctl is-active --quiet tailscaled; then
    sudo systemctl enable --now tailscaled
fi

TAILSCALE_STATE="$(
    tailscale status --json 2>/dev/null \
        | sed -n 's/.*"BackendState"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
        | head -n 1
)"

echo "Tailscale backend state: ${TAILSCALE_STATE:-unknown}"

if [[ "$TAILSCALE_STATE" != "Running" ]]; then
    echo
    echo "Tailscale is not running. Bringing it up..."
    echo

    if [[ -n "${TAILSCALE_AUTHKEY:-}" ]]; then
        tailscale up --ssh --authkey="$TAILSCALE_AUTHKEY"
    else
        tailscale up --ssh || true
    fi

    # Re-check state; if still not running, a login URL was printed and we must wait.
    TAILSCALE_STATE="$(
        tailscale status --json 2>/dev/null \
            | sed -n 's/.*"BackendState"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
            | head -n 1
    )"

    if [[ "$TAILSCALE_STATE" != "Running" ]]; then
        echo
        echo "Tailscale state is still '${TAILSCALE_STATE:-unknown}' after 'tailscale up'."
        echo "If a login URL was printed above, open it in your browser."
        echo "After approving the machine, re-run this script."
        exit 0
    fi

    echo "Tailscale is now running."
else
    echo "Tailscale is already running."
fi

echo
echo "Tailscale IP:"
tailscale ip -4 || true
echo

# -----------------------------
# 2. Install Claude Code
# -----------------------------
if ! command -v claude >/dev/null 2>&1; then
    echo "Claude Code not found. Installing..."
    curl -fsSL https://claude.ai/install.sh | bash

    # Common user-local binary locations.
    export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
    hash -r
else
    echo "Claude Code already installed."
fi

if ! command -v claude >/dev/null 2>&1; then
    echo "ERROR: Claude installed, but 'claude' is still not on PATH."
    echo "Open a new terminal, run 'claude --version', then re-run this script."
    exit 1
fi

echo "Claude version:"
claude --version || true
echo

echo "NOTE: If Claude is not logged in yet, run this manually once:"
echo "  claude"
echo

# TODO: run claude in tmux
# tmux new -s slack-agent
# ----------------------------- # 5. Start Slack relay in tmux # ----------------------------- 
# SESSION_NAME="${SESSION_NAME:-slack-agent}" RUN_IN_TMUX="${RUN_IN_TMUX:-1}" if [[ "$RUN_IN_TMUX" == "1" ]]; then if ! command -v tmux >/dev/null 2>&1; then echo "tmux not found. Installing..." sudo apt-get update sudo apt-get install -y tmux fi if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then echo "tmux session '$SESSION_NAME' is already running." echo echo "Attach with:" echo " tmux attach -t $SESSION_NAME" echo echo "Restart it with:" echo " tmux kill-session -t $SESSION_NAME" echo " $0" exit 0 fi echo "Starting bot in tmux session: $SESSION_NAME" tmux new-session -d \ -s "$SESSION_NAME" \ -c "$PROJECT_DIR" \ "bash -lc 'source \"$VENV_DIR/bin/activate\" && exec python \"$BOT_PY\"'" echo echo "Bot started." echo echo "Attach with:" echo " tmux attach -t $SESSION_NAME" echo echo "Detach from tmux with:" echo " Ctrl+b, then d" echo echo "Stop the bot with:" echo " tmux kill-session -t $SESSION_NAME" else echo "Starting bot in foreground..." exec python "$BOT_PY" fi
# -----------------------------
# 3. Check project files
# -----------------------------

if [[ ! -f "$BOT_PY" ]]; then
    echo "ERROR: $BOT_BY not found:"
    exit 1
fi

# -----------------------------
# 4. Python venv + dependencies
# -----------------------------
cd "$PROJECT_DIR"
#
# if [[ ! -d "$VENV_DIR" ]]; then
#     echo "Creating Python virtual environment..."
#     python3 -m venv "$VENV_DIR"
# fi
#
# source "$VENV_DIR/bin/activate"
#
# python -m pip install -U pip
#
# if [[ -f "$PROJECT_DIR/requirements.txt" ]]; then
#     echo "Installing Python dependencies from requirements.txt..."
#     python -m pip install -r "$PROJECT_DIR/requirements.txt"
# else
#     echo "No requirements.txt found. Installing basic Slack bot dependencies..."
#     python -m pip install slack_bolt python-dotenv
# fi
#
# if [[ ! -f "$PROJECT_DIR/.env" ]]; then
#     echo
#     echo "WARNING: .env not found."
#     echo "Expected something like:"
#     echo "  SLACK_BOT_TOKEN=xoxb-..."
#     echo "  SLACK_APP_TOKEN=xapp-..."
#     echo "  ALLOWED_USER_IDS=U..."
#     echo
# fi
#
# # -----------------------------
# # 5. Start bot.py
# # -----------------------------
# echo
# echo "Starting bot.py..."
# echo "Press Ctrl+C to stop."
# echo
#
# exec python "$BOT_PY"
