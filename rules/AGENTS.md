# Antigravity Development Guidelines & Rules

This plugin provides comprehensive development workflows, best practices, rules, and skills for Antigravity CLI.

## Core Principles

### 1. Security First

Before ANY commit:
- No hardcoded secrets (API keys, passwords, tokens)
- All user inputs validated (using schemas such as Zod)
- SQL injection prevention (parameterized queries)
- XSS prevention (sanitized HTML)
- CSRF protection enabled
- Authentication/authorization verified
- Rate limiting on all endpoints
- Error messages don't leak sensitive data

**Secret Management:**
```typescript
// NEVER: Hardcoded secrets
const apiKey = "sk-proj-xxxxx"

// ALWAYS: Environment variables
const apiKey = process.env.OPENAI_API_KEY

if (!apiKey) {
  throw new Error('OPENAI_API_KEY not configured')
}
```

**Security Response Protocol:**
If security issue found:
1. STOP immediately
2. Run `/security-review` (or `/code-review`)
3. Fix CRITICAL issues before continuing
4. Rotate any exposed secrets
5. Review entire codebase for similar issues

### 2. Coding Style

**Immutability (CRITICAL):**
ALWAYS create new objects, NEVER mutate:

```javascript
// WRONG: Mutation
function updateUser(user, name) {
  user.name = name  // MUTATION!
  return user
}

// CORRECT: Immutability
function updateUser(user, name) {
  return {
    ...user,
    name
  }
}
```

**File Organization:**
MANY SMALL FILES > FEW LARGE FILES:
- High cohesion, low coupling
- 200-400 lines typical, 800 max
- Extract utilities from large components
- Organize by feature/domain, not by type

**Error Handling:**
ALWAYS handle errors comprehensively:

```typescript
try {
  const result = await riskyOperation()
  return result
} catch (error) {
  console.error('Operation failed:', error)
  throw new Error('Detailed user-friendly message')
}
```

**Input Validation:**
ALWAYS validate user input:

```typescript
import { z } from 'zod'

const schema = z.object({
  email: z.string().email(),
  age: z.number().int().min(0).max(150)
})

const validated = schema.parse(input)
```

**Code Quality Checklist:**
Before marking work complete:
- [ ] Code is readable and well-named
- [ ] Functions are small (<50 lines)
- [ ] Files are focused (<800 lines)
- [ ] No deep nesting (>4 levels)
- [ ] Proper error handling
- [ ] No console.log statements
- [ ] No hardcoded values
- [ ] No mutation (immutable patterns used)

### 3. Testing Requirements

**Minimum Test Coverage: 80%**

Test Types (ALL required):
1. **Unit Tests** - Individual functions, utilities, components
2. **Integration Tests** - API endpoints, database operations
3. **E2E Tests** - Critical user flows (Playwright)

**Test-Driven Development:**
MANDATORY workflow:
1. Write test first (RED)
2. Run test - it should FAIL
3. Write minimal implementation (GREEN)
4. Run test - it should PASS
5. Refactor (IMPROVE)
6. Verify coverage (80%+)

### 4. Git Workflow

> [!CRITICAL]
> **APROVAÇÃO OBRIGATÓRIA PARA COMMIT & PUSH:**
> NUNCA execute `git commit` ou `git push` automaticamente sem a solicitação ou aprovação direta e explícita do usuário.
> Mesmo após concluir implementações, revisões de código ou testes com sucesso, apresente os resultados, testes e arquivos modificados e aguarde a autorização expressa do usuário antes de criar commits ou enviar alterações para o repositório remoto.

**Commit Message Format:**
```
<type>: <description>

<optional body>
```

Types: feat, fix, refactor, docs, test, chore, perf, ci

**Feature Implementation Workflow:**
1. **Plan First** - Use `/plan` skill/command to create implementation plan
2. **TDD Approach** - Use `/tdd` skill/command
3. **Code Review** - Use `/code-review` skill/command immediately after writing code
4. **Security Review** - Review security checklist
5. **Report & Request Approval** - Present status, diff summary, test results, and wait for user's explicit approval
6. **Commit & Push (ONLY with Direct Approval)** - Execute commit and push only after direct user confirmation

### 5. Performance Optimization

**Context Window Management:**
Avoid last 20% of context window for:
- Large-scale refactoring
- Feature implementation spanning multiple files
- Debugging complex interactions

Lower context sensitivity tasks:
- Single-file edits
- Independent utility creation
- Documentation updates
- Simple bug fixes

### 6. Common Patterns

**API Response Format:**
```typescript
interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
  meta?: {
    total: number
    page: number
    limit: number
  }
}
```

**Custom Hooks Pattern:**
```typescript
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value)

  useEffect(() => {
    const handler = setTimeout(() => setDebouncedValue(value), delay)
    return () => clearTimeout(handler)
  }, [value, delay])

  return debouncedValue
}
```

**Repository Pattern:**
```typescript
interface Repository<T> {
  findAll(filters?: Filters): Promise<T[]>
  findById(id: string): Promise<T | null>
  create(data: CreateDto): Promise<T>
  update(id: string, data: UpdateDto): Promise<T>
  delete(id: string): Promise<void>
}
```
