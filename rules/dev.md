# Development Context & Rules

Active development guidelines when implementing features or fixing bugs.

## Active Development Guidelines

1. **Follow TDD** - Write tests before implementation (RED -> GREEN -> REFACTOR)
2. **Small commits** - Commit frequently with clear conventional commit messages
3. **Run tests often** - Verify changes don't break existing code
4. **Check types** - Run `npx tsc --noEmit` regularly
5. **Lint check** - Run linter before committing

## Pre-Commit Verification
- [ ] Tests passing (`npm test`)
- [ ] Types checking (`npx tsc --noEmit`)
- [ ] No lint errors (`npm run lint`)
- [ ] No `console.log` statements
- [ ] Meaningful commit message
