---
name: eli5
description: Explain an algorithm, pipeline or system as a numbered story in execution order, each step with its reason and evidence. Use when Rico asks for an ELI5, "how does X work", or to check or straighten out his notes.
---

# ELI5: clear and coherent

## Structure
1. Number the steps in the order the system runs them, from input to output. Don't group by topic.
2. Each step gives what happens, why it is needed, and what it produces for the next step.
    - If the reason is not obvious, place the reason with the step. For example, the user could ask "why is there slope?". Then, answer it right there: the tilt is decimeters and the texture is 5 cm. 
3. If a step exists because of a measurement, put the measurement right before it, then "therefore …".
4. End with what the output is used for, and what this system does NOT do (e.g. "halo builds no map; the map is ours").

## Wording
- Plain operational words first ("slide", "fake scores", "blurred copy subtracted"), then the formal term once in parentheses.
- Name the exact operation, with its reason in a few words: "images encoded as JPEG (to save RAM), then shown", not "stored as JPEG".
- Give each number its scale or consequence: "tilt is decimeters, texture is 5 cm"; "30 fake scores at 2 per mosaic = 15 mosaics, about 75 s before any loop".
- One idea per line, nested at most 3 levels deep.
- Say which component owns each step when there are several (halo vs our map_blobs.py vs the CNN).

## When checking the user's notes
- Keep their wording, numbering style and examples wherever they are right.
- Work corrections into the steps. Don't return a separate list of corrections.
- Put missing steps where they belong in the order.
- Answer their TODOs and questions inline at the step where they were asked.
- After the rewrite, list in at most 5 lines what changed, so the corrections stay visible.

## Before writing
- Verify every claim against the code or data, not memory. If something can't be verified, mark it as unverified.
- Don't skip precise conditions (thresholds, per-layer vs pooled, distance vs time) just because the story reads better without them.

## Don't
- Hand over a pile of verified facts with no order.
- Lead with jargon or parameter names.
- Mix two systems' steps without labeling them.
