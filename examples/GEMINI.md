# Example Project GEMINI.md

This is an example project-specific GEMINI.md file. Copy and customize for your projects.

## Project Overview

[Describe your project here]

**Tech Stack:**
- Frontend: [e.g., Next.js 15, React, TypeScript]
- Backend: [e.g., Node.js, FastAPI]
- Database: [e.g., PostgreSQL, Supabase]
- Deployment: [e.g., Vercel, Cloud Run]

## Project Structure

```
project/
├── src/
│   ├── app/           # Next.js pages
│   ├── components/    # React components
│   ├── lib/           # Utilities
│   └── types/         # TypeScript types
├── tests/             # Test files
└── docs/              # Documentation
```

## Development Guidelines

### Coding Style

1. **TypeScript** for all new code
2. **Functional components** with hooks
3. **Immutability** - never mutate objects/arrays
4. **Small files** - 200-400 lines typical

### Testing

- **80% coverage** minimum
- **TDD approach** - write tests first
- **E2E tests** for critical flows

### Git Workflow

```bash
# Feature branch
git checkout -b feature/my-feature

# Commit format
git commit -m "feat: add user authentication"

# Before PR
npm test && npm run lint
```

## Commands

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm run build` | Build for production |
| `npm test` | Run tests |
| `npm run lint` | Lint code |

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `DATABASE_URL` | Yes | Database connection string |
| `NEXTAUTH_SECRET` | Yes | Auth secret |
| `API_KEY` | No | External API key |

## Common Patterns

### API Response

```typescript
interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
}
```

### Error Handling

```typescript
try {
  const result = await operation()
  return { success: true, data: result }
} catch (error) {
  console.error('Operation failed:', error)
  return { success: false, error: 'Operation failed' }
}
```

## Deployment

1. Ensure tests pass: `npm test`
2. Build: `npm run build`
3. Deploy: `[your deployment command]`

## Resources

- [Project Documentation](./docs/)
- [API Documentation](./docs/api.md)
- [Contributing Guide](./CONTRIBUTING.md)
