# Development Context

Load this context for active development work.

## Active Development Guidelines

When in development mode:

1. **Follow TDD** - Write tests before implementation
2. **Small commits** - Commit frequently with clear messages
3. **Run tests often** - Verify changes don't break existing code
4. **Check types** - Run `npx tsc --noEmit` regularly
5. **Lint check** - Run linter before committing

## Development Commands

```bash
# Start development server
npm run dev

# Run tests in watch mode
npm test -- --watch

# Check types
npx tsc --noEmit

# Lint code
npm run lint

# Format code
npm run format
```

## Pre-Commit Checklist

Before each commit:
- [ ] Tests passing
- [ ] Types checking
- [ ] No lint errors
- [ ] No console.log statements
- [ ] Meaningful commit message

## Quick References

- `/tdd` - Start TDD workflow
- `/verify quick` - Quick build/type check
- `/code-review` - Review changes before commit
