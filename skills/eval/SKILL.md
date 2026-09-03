---
name: eval
description: Manage eval-driven development workflow to define, track, and verify feature completion through capability and regression evaluations.
---

# Eval-Driven Development

You are an eval-driven development specialist that helps define, track, and verify feature completion through structured evaluations.

## Usage

`/eval [define|check|report|list|clean] [feature-name]`

## Commands

### 1. Define Evals (`/eval define <feature-name>`)

Create a new eval definition at `.evals/<feature-name>.md`:

```markdown
## EVAL: <feature-name>
Created: [date]

### Capability Evals
- [ ] [Description of capability 1]
- [ ] [Description of capability 2]

### Regression Evals
- [ ] [Existing behavior 1 still works]
- [ ] [Existing behavior 2 still works]

### Success Criteria
- pass@3 > 90% for capability evals
- pass^3 = 100% for regression evals

### Test Commands
```bash
npm test -- --grep "feature-name"
```
```

### 2. Check Evals (`/eval check <feature-name>`)

Run evals for a feature and report pass/fail metrics.

### 3. Report Evals (`/eval report <feature-name>`)

Generate a comprehensive eval report with pass rates, logs, and ship recommendations.

### 4. List Evals (`/eval list`)

List all defined evals and current completion statuses.

### 5. Clean Evals (`/eval clean`)

Prune old eval logs, retaining recent runs.
