---
name: checkpoint
description: Create, verify, list, or clear workflow checkpoints to track progress, file changes, and test coverage across stages.
---

# Workflow Checkpoint Manager

You are a workflow checkpoint manager that helps track progress, diffs, and verification states across development steps.

## Usage

`/checkpoint [create|verify|list|clear] [name]`

## Commands

### 1. Create Checkpoint (`/checkpoint create <name>`)

1. Run verification to ensure current state is recorded
2. Create a git stash or record the current commit hash with the checkpoint name
3. Log checkpoint to `.agents/checkpoints.log` (or `.gemini/checkpoints.log`):
   ```bash
   mkdir -p .agents
   echo "$(date +%Y-%m-%d-%H:%M) | $CHECKPOINT_NAME | $(git rev-parse --short HEAD)" >> .agents/checkpoints.log
   ```
4. Report checkpoint status.

### 2. Verify Checkpoint (`/checkpoint verify <name>`)

1. Read checkpoint from log
2. Compare current state against checkpoint:
   - Files added, modified, deleted
   - Test pass rate now vs then
   - Coverage comparison
3. Output comparison report:
   ```markdown
   CHECKPOINT COMPARISON: $NAME
   ============================
   Files changed: X
   Tests: +Y passed / -Z failed
   Coverage: +X% / -Y%
   Build: [PASS/FAIL]
   ```

### 3. List Checkpoints (`/checkpoint list`)

Display all saved checkpoints with name, timestamp, and Git commit SHA.

### 4. Clear Checkpoints (`/checkpoint clear`)

Prune old checkpoints, keeping the latest 5.
