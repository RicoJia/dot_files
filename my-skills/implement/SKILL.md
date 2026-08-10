---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /code-review to review the work.

Commit your work to the current branch.

## Editing rules

- Do not modify files under `build/`, `install/`, or `log/` unless explicitly asked.
- Do not read or print secrets, `.env` files, SSH keys, API keys, tokens, credentials, or private config files.
- Do not push to remote unless explicitly asked.
- Do not delete branches.
- Keep changes small and reviewable.
- Prefer explaining the plan before making broad refactors.

- minimize the amount of files to keep, keep individual components distinct
- please keep variables easy to understand and word order consistent with english. E.g., not `boat_a` but `boat_albedo`

## Response style / token discipline

- Be concise by default.
- Do not include motivational text or long explanations.
- Do not paste full logs.
- For command output, summarize root cause only.
- Keep final responses under 30 lines unless Rico asks for detail.
- If more detail is needed, ask before expanding.rjia@hammurabi:~/volume/pose_estimate_rico_ws/src$ 
