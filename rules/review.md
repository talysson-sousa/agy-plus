# Code Review Rules & Checklist

Guidelines for inspecting and reviewing code before merge.

## Review Priorities

1. **Security (CRITICAL)**: Check for secrets, SQL injection, XSS, insecure dependencies, authorization bypasses.
2. **Quality (HIGH)**: Enforce immutability, small functions (<50 lines), small files (<400 lines), no console.logs.
3. **Performance (MEDIUM)**: Check for N+1 queries, unmemoized expensive calculations, large bundles.
4. **Best Practices (MEDIUM)**: Test coverage >= 80%, clear variable names, accurate error handling.
