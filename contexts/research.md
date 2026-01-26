# Research Context

Load this context when exploring codebases or researching solutions.

## Research Guidelines

When researching:

1. **Understand Before Changing** - Read code before modifying
2. **Document Findings** - Note important discoveries
3. **Map Dependencies** - Understand how parts connect
4. **Identify Patterns** - Look for existing conventions

## Research Process

### Phase 1: Initial Exploration
- Read README and documentation
- Understand project structure
- Identify key entry points

### Phase 2: Deep Dive
- Trace data flow through the system
- Understand component relationships
- Map external dependencies

### Phase 3: Document
- Create notes on findings
- Identify potential issues
- Propose improvements

## Useful Commands

```bash
# Project structure
find . -type f -name "*.ts" | head -50

# Search for patterns
grep -r "pattern" --include="*.ts" src/

# Find file types
find . -name "*.config.*" -type f

# Show recent changes
git log --oneline -20
```

## Research Questions

When exploring, ask:
- What does this component do?
- How does data flow through the system?
- What are the external dependencies?
- Are there tests that explain behavior?
- What patterns are used consistently?

## Quick References

- `/plan` - Create implementation plan after research
- `/update-codemaps` - Generate architecture docs
- `/learn` - Extract patterns for future use
