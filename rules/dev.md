# Development Context & Rules

Active development guidelines when implementing features or fixing bugs.

## Active Development Guidelines

1. **Follow TDD** - Write tests before implementation (RED -> GREEN -> REFACTOR)
2. **Never Commit/Push Without Approval** - NUNCA execute `git commit` ou `git push` sem aprovação direta e expressa do usuário
3. **Small commits** - When approved, commit with clear conventional commit messages
4. **Run tests often** - Verify changes don't break existing code
5. **Check types** - Run `npx tsc --noEmit` regularly
6. **Lint check** - Run linter before requesting commit approval

## Pre-Commit Verification
- [ ] Tests passing (`npm test`)
- [ ] Types checking (`npx tsc --noEmit`)
- [ ] No lint errors (`npm run lint`)
- [ ] No `console.log` statements
- [ ] Explicit user approval received for commit & push
- [ ] Meaningful commit message
