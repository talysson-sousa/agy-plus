# agy-plus

A comprehensive plugin for **Google Antigravity CLI (`agy`)** and **Antigravity 2.0 / IDE** with slash command workflows, progressive-disclosure skills, lifecycle hooks, rules, and Model Context Protocol (MCP) integrations for high-performance software development.

## Credits & Attribution

This project is adapted from **[everything-gemini-cli](https://github.com/pm-bhatt/everything-gemini-cli)** and the original **[everything-claude-code](https://github.com/affaan-m/everything-claude-code)** by **[Affaan Mustafa](https://x.com/affaanmustafa)** (Anthropic hackathon winner).

---

## Features

- **29 Skills & Slash Commands**:
  - **15 Workflow Skills**: Directly invocable as slash commands (`/plan`, `/tdd`, `/code-review`, `/build-fix`, `/verify`, `/e2e`, `/refactor-clean`, `/checkpoint`, `/learn`, `/eval`, `/orchestrate`, `/test-coverage`, `/update-docs`, `/update-codemaps`, `/setup-pm`).
  - **14 Domain & Engineering Skills**: Context-aware, progressive disclosure guides (`backend-patterns`, `frontend-patterns`, `postgres-patterns`, `clickhouse-io`, `security-review`, `coding-standards`, `continuous-learning`, `continuous-learning-v2`, `eval-harness`, `iterative-retrieval`, `strategic-compact`, `tdd-workflow`, `verification-loop`, `project-guidelines-example`).
- **Antigravity Lifecycle Hooks (`hooks.json`)**:
  - `PreToolUse`: Automated safety gate on `run_command` (prevents destructive commands like `rm -rf /`, force push to main, raw disk writes) via `scripts/safety-check.sh`.
  - `PreInvocation`: Optional guideline reminders for TDD, security, and immutability standards via `scripts/reminder.sh`.
- **Global & Workspace Rules (`rules/AGENTS.md`)**:
  - Security First, Immutability by default, Many Small Files principle, 80%+ test coverage, Git workflows.
- **MCP Server Configurations (`mcp_config.json`)**:
  - Preconfigured definitions for GitHub, Memory, Sequential Thinking, Firecrawl, Supabase, Vercel, Context7, and Filesystem servers.

---

## Quick Installation (Global in `~/.gemini`)

### Method 1: Antigravity CLI Command (Recommended)

From the root of this repository:

```bash
agy plugin install .
```

To verify:
```bash
agy plugin list
```

### Method 2: Helper Script

```bash
./install.sh
```

### Uninstallation

```bash
agy plugin uninstall agy-plus
# or:
./uninstall.sh
```

---

## Plugin Directory Structure

```
agy-plus/
├── plugin.json               # Plugin manifest
├── mcp_config.json           # Antigravity MCP servers
├── hooks.json                # Lifecycle hooks (PreToolUse safety checks, etc.)
├── install.sh                # Global installer script (~/.gemini/config/plugins)
├── uninstall.sh              # Global uninstaller script
├── rules/                    # Rules applied when plugin is active
│   ├── AGENTS.md             # Core rules & coding standards
│   ├── dev.md                # Development mode guidelines
│   ├── review.md             # Code review guidelines
│   └── research.md           # Research & exploration guidelines
├── scripts/                  # Executable hook scripts
│   ├── safety-check.sh       # PreToolUse command interceptor
│   └── reminder.sh           # PreInvocation reminder generator
├── skills/                   # 29 Antigravity Skills (with SKILL.md frontmatter)
│   ├── plan/SKILL.md         # /plan
│   ├── tdd/SKILL.md          # /tdd
│   ├── code-review/SKILL.md  # /code-review
│   ├── build-fix/SKILL.md    # /build-fix
│   ├── verify/SKILL.md       # /verify
│   ├── e2e/SKILL.md          # /e2e
│   ├── refactor-clean/SKILL.md
│   ├── checkpoint/SKILL.md
│   ├── learn/SKILL.md
│   ├── eval/SKILL.md
│   ├── orchestrate/SKILL.md
│   ├── test-coverage/SKILL.md
│   ├── update-docs/SKILL.md
│   ├── update-codemaps/SKILL.md
│   ├── setup-pm/SKILL.md
│   ├── backend-patterns/SKILL.md
│   ├── frontend-patterns/SKILL.md
│   ├── postgres-patterns/SKILL.md
│   ├── clickhouse-io/SKILL.md
│   ├── security-review/SKILL.md
│   ├── coding-standards/SKILL.md
│   └── ...
└── docs/                     # Documentation and parity references
```

---

## Usage Guide

### 1. Workflow Slash Commands

Type any of the following commands in the Antigravity CLI prompt:

| Command | Description |
|---|---|
| `/plan` | Restate requirements, assess risks, and draft an implementation plan before writing code |
| `/tdd` | Scaffold types, write failing tests (RED), implement minimal code (GREEN), refactor |
| `/code-review` | Comprehensive security, quality, performance, and best practice review of changes |
| `/build-fix` | Incrementally analyze and resolve TypeScript and build compilation errors safely |
| `/verify` | Run complete verification suite (build, types, linter, tests, console.logs, git status) |
| `/e2e` | Generate and execute Playwright end-to-end tests with Page Object Model and artifact capture |
| `/refactor-clean` | Safely detect and eliminate dead code and unused dependencies with test gates |
| `/checkpoint` | Create, verify, list, or clear workflow checkpoints and compare diffs |
| `/learn` | Extract reusable patterns and debugging solutions from current session as new skills |
| `/eval` | Manage eval-driven development with capability and regression test criteria |
| `/orchestrate` | Coordinate multi-step workflows (feature, bugfix, refactor, security, or custom chains) |
| `/test-coverage` | Analyze coverage gaps and generate tests to meet the 80%+ threshold |
| `/update-docs` | Sync `CONTRIBUTING.md`, `RUNBOOK.md`, and API docs from source-of-truth files |
| `/update-codemaps` | Generate and update token-lean architecture codemaps |
| `/setup-pm` | Detect, configure, or switch the project's package manager (npm, pnpm, yarn, bun) |

### 2. Domain & Engineering Skills

Antigravity automatically discovers and activates these skills via semantic matching, or you can invoke them directly:

| Skill | Activation Trigger / Purpose |
|---|---|
| `backend-patterns` | API design, repository pattern, database query optimization, error handling |
| `frontend-patterns` | React/Next.js components, custom hooks, state management, UI patterns |
| `postgres-patterns` | PostgreSQL query optimization, indexes, migrations, RLS policies |
| `clickhouse-io` | High-throughput analytics, ClickHouse schema design and aggregations |
| `security-review` | Authentication, authorization, input validation, SQL injection, XSS, secrets |
| `coding-standards` | Immutability, small functions, error handling, TypeScript best practices |
| `tdd-workflow` | Comprehensive test-driven development methodologies |
| `iterative-retrieval` | Efficient context searching and code exploration strategies |
| `eval-harness` | Systematic evaluation setups and test harness creation |
| `verification-loop` | Quality gate enforcement and validation loops |
| `continuous-learning` / `continuous-learning-v2` | Instinct-based pattern capture and session learning |
| `strategic-compact` | Managing context window limits and optimizing token usage |
| `project-guidelines-example` | Template for project-specific customization guidelines |

---

## MCP Server Configuration

The plugin provides ready-to-use MCP configurations in `mcp_config.json`. Configure your environment variables as needed:

- `GITHUB_PERSONAL_ACCESS_TOKEN`: For GitHub operations and PR management.
- `FIRECRAWL_API_KEY`: For web scraping and search integrations.
- `SUPABASE_PROJECT_REF`: For Supabase database operations.

---

## License

MIT License - see [LICENSE](LICENSE) file.
