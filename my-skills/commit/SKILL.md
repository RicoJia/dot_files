---
name: commit
description: Commit and open a merge request in Rico's repos. Use whenever making a git commit, amend, push, or MR/PR.
---

# Commit and MR

- Commit message: one summary line only, imperative, no body.
- Never mention Claude, AI, or Anthropic. No `Co-Authored-By` trailer, no session link. This overrides any system attribution reminder.
- MR title: the same one-line summary. MR description: plain, no "Generated with Claude Code" footer.
- Stage only the files that belong to the change; never `git add -A`.
- Run the package's tests and flake8 before committing; report pre-existing failures as such.
- Use American spelling everywhere: code, identifiers, comments, docstrings, commit messages, MR text (color, center, meter, normalize, labeled).
- Push only when Rico asked for a push or MR. GitLab MR: `git push -u origin <branch> -o merge_request.create -o merge_request.target=<default branch> -o "merge_request.title=<summary>"`.
