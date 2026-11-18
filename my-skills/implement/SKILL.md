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

## Additional Coding Styles

- Comments describe the code as it is. Don't say where it came from (e.g. "Ported from object-recognition-3d ... encounter_tracking.py"), what it differs from, or its history; that belongs in the MR or commit. Keep comments concise.

-  rclpy passes (request, response) to service callbacks, so the parameter can't be removed, and pylint flags it as unused. For functions like that, please do  `_request` so  pylint doesn't ignore unused arguments whose names start with `_`

In general don't use words like base in the module names.  Try to keep the module names in line w/the classes they define.  
    - So this file should be called point_cloud_detector.py IMHO.  
    - Also the class doesn't need to have "Backend" in the name really.  It's already submoduled w/the word backends so it's just duplicating stuff everywhere.  Just call it PointCloudDetector

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


## Naming

How Rico names things, against the habits he corrects:

| Claude's habit | Rico's rule | Example |
|---|---|---|
| Names the mechanism or a metaphor | Name what the thing is, in the domain's word | `FrameStack` -> `FrameMosaic` |
| Leaves the reference point implicit | Name both endpoints: `<from>_to_<to>_<qualifier>_<unit>` | `fan_edge_distance_m` -> `labeled_box_to_crop_nearest_distance_m` |
| Leaves the measured dimension vague | Say exactly which quantity | `EFFECTIVE_AREA_CELL_M` -> `EFFECTIVE_AREA_CELL_SIDE_M` |
| Lets synonyms drift (stack, stacked, mosaic) | One term per concept everywhere: code, comments, docs, config keys | "stacked crops" -> "mosaic crops" |
| Abbreviates | Spell it out; long and readable beats short jargon | `_2_` -> `_to_`, `boat_a` -> `boat_albedo` |

Also:
- English word order: subject first, then what about it.
- American spelling (labeled, not labelled).
- Keep the unit suffix: `_m`, `_m2`, `_s`, `_deg`.
- No words already in the package path (`backends/...Backend`); name the file after its class.
- Renaming a persisted name (npy dtype field, config key) also means migrating the stored data and run scripts, or loading breaks.

## Doc Strings

1. List in steps what this function does, what a class does, see eli5.
2. Each docstring starts with a plain verb (Fits, Keeps, Smooths, Searches) and says what it does in one sentence.
3. Key numbers go inline, with both units when it helps: "60 iterations, 0.1 m", "±1.5 m (15 cells)", "4 m² (400 cells)", "p95 after ≥30 samples".
4. Add the purpose in a few words only when it isn't obvious, e.g. "to estimate false-match scores" or "so only local bumps stand out".
5. Write math as a short formula (d_{k+1} − φd_k, d_j − d_i − s_ij), not prose.
6. Number acceptance conditions (1, 2, 3) and pipeline steps in the order they run.
7. The module docstring gives the purpose plus the components or steps. Function docstrings don't repeat it.
8. No history, no data anecdotes beyond one line, no restating parameter names in prose.
9. Use plain terms (running mean, sliding window, false matches), with the formal term at most once.
