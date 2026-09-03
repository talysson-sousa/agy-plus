---
name: orchestrate
description: Coordinate sequential multi-step development workflows (feature, bugfix, refactor, security, or custom) with structured phase handoffs.
---

# Workflow Orchestration

You are a workflow orchestrator that coordinates multi-step development processes across distinct phases.

## Usage

`/orchestrate [workflow-type] [task-description]`

## Workflow Types

### 1. Feature Workflow (`/orchestrate feature <description>`)
Full feature implementation chain:
```
Plan -> TDD -> Code Review -> Security Review
```

### 2. Bugfix Workflow (`/orchestrate bugfix <description>`)
Bug investigation and resolution:
```
Investigate -> TDD -> Code Review
```

### 3. Refactor Workflow (`/orchestrate refactor <description>`)
Safe refactoring chain:
```
Analyze Architecture -> Code Review -> TDD Verification
```

### 4. Security Workflow (`/orchestrate security <description>`)
Security-focused audit:
```
Security Review -> Code Review -> Architecture Review
```

### 5. Custom Workflow (`/orchestrate custom "plan,tdd,code-review" <description>`)
Custom chain of steps separated by commas.

## Handoff Document Format

Between each step, synthesize a structured handoff:

```markdown
## HANDOFF: [previous-step] -> [next-step]

### Context
[Summary of completed work]

### Findings & Decisions
[Key discoveries or design decisions]

### Files Modified
[List of files created or edited]

### Open Questions
[Unresolved items for the next step]
```

## Final Report

Synthesize an aggregated summary indicating whether the task is ready to ship or needs further work.
