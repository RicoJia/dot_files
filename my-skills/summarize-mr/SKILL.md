---
name: summarize-mr
description: Summarize a merge request file by file. Use when Rico asks for an MR summary, a "file item summary", or what an MR or branch changes.
---

# Summarize an MR, file by file

## Get the diff from git, not the web page
GitLab pages (code.hmech.us) are private and can't be fetched.
1. `git fetch origin`, then find the MR branch and its target (`git remote show origin` gives the default).
2. Check the local branch matches the pushed one: `git rev-parse --short HEAD origin/<branch>`. Summarize what is pushed; say so if local differs.
3. `git diff --stat origin/<target>...origin/<branch>` for the files and line counts; `git log --oneline origin/<target>..origin/<branch>` for the commits.
4. Read each file's diff (and new modules' docstrings and function lists) before describing it.

## Layout
1. One header line: MR number, branch -> target, commits, files, +/- lines.
2. Group files by component (e.g. "object-ojos", "step1 conversion"), the main file first.
3. Per file: name, line counts, one line on what it is, then its changes in the eli5 style (see the eli5 skill):
    - Number the changes in the order the code runs them, from input to output, not by topic.
    - Each step says what happens, why (in a few words, if not obvious), and what it gives the next step.
    - Plain operational words first, the formal term once in parentheses; at most 3 levels deep.

## Wording (eli5's wording rules, plus)
- Name the exact operation, not a generic one: "images encoded as JPEG", not "stored as JPEG"; "drops", "projects", "logs", "reads".
- Keep the reason in a few words when it isn't obvious: "encoded as JPEG (to save RAM), then shown in the viewer".
- Keep the details that change behavior: numbers with units ("0.05 rad tolerance"), flag names (`--map MAP_DIR`), what the user sees.
- Short: one idea per line, no filler words, no restating the file name in prose.
- Use the project's terms (detections, tracks, encounters, map), the same word for one thing throughout.

## Don't
- Describe a file from memory or from the commit messages alone.
- Paste the diff or list every function.
- Add commit hashes per file, or mention Claude.
