# Code Review Context

Load this context when reviewing code or preparing PRs.

## Review Guidelines

When reviewing code:

1. **Security First** - Check for vulnerabilities
2. **Code Quality** - Readability, maintainability
3. **Test Coverage** - Adequate tests for changes
4. **Performance** - No obvious bottlenecks
5. **Best Practices** - Follows project conventions

## Review Checklist

### Security
- [ ] No hardcoded secrets
- [ ] Input validation present
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] Proper authentication checks

### Code Quality
- [ ] Functions < 50 lines
- [ ] Files < 800 lines
- [ ] No deep nesting (> 4 levels)
- [ ] Proper error handling
- [ ] No console.log statements

### Tests
- [ ] New code has tests
- [ ] Edge cases covered
- [ ] Coverage > 80%

### Performance
- [ ] No N+1 queries
- [ ] Appropriate caching
- [ ] No unnecessary re-renders

## Review Commands

```bash
# See what changed
git diff --stat

# See detailed changes
git diff

# Run tests for coverage
npm run test:coverage

# Check for issues
npm run lint
```

## Quick References

- `/code-review` - Run full code review
- `/verify pre-pr` - Pre-PR verification
- `/test-coverage` - Check coverage gaps
