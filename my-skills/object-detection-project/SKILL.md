---
name: object-detection-project
description: Rules for Rico's CODA sonar mine / crab-trap detection project (object-recognition-3d). Use when starting or reporting work on its data, training or evaluation.
---

# Object detection project

## Goal

- Mines: 90% encounter accuracy at 0.1% encounter false positives.
- When benchmarking, list encounter accuracy, number of trap encounters called mine, and mine encounters called trap

## Start of every task

- List the data counts first:
  - encounters identified: traps, mines
  - raw crops: traps, mines, seabed

## Naming

- Don't name things with a bare adjective: `stacked_frames`, not `stacked`.
