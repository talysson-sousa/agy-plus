# Feature Parity with Claude Code

This document details feature availability between everything-claude-code and everything-gemini-cli.

## Full Feature Parity

These features work identically in both systems:

| Feature | Status | Notes |
|---------|--------|-------|
| Custom Commands | Full | TOML format instead of Markdown |
| Skills | Full | Same SKILL.md format |
| MCP Servers | Full | Same configuration structure |
| Context Files | Full | GEMINI.md instead of CLAUDE.md |

## Partial Feature Parity

These features have limited support:

### Hooks

| Hook Type | Claude Code | Gemini CLI | Workaround |
|-----------|-------------|------------|------------|
| PreToolUse | Full support | Not supported | Manual checklist |
| PostToolUse | Full support | Not supported | Manual checklist |
| PreCompact | Full support | Not supported | N/A |
| SessionStart | Full support | BeforeAgent | Partial support |
| SessionEnd | Full support | Not supported | N/A |
| Stop | Full support | Not supported | N/A |

**Impact**: Automated checks (formatting, type checking, security scans) must be run manually.

**Workaround**: GEMINI.md includes manual checklists for common automated checks.

### Agents

| Feature | Claude Code | Gemini CLI | Workaround |
|---------|-------------|------------|------------|
| Named agents | Yes | No | Inline in prompts |
| Tool restrictions | Yes | No | N/A |
| Model selection | Yes | No | N/A |
| Specialized roles | Yes | No | Role instructions in prompt |

**Impact**: Cannot restrict tools or select models per-agent.

**Workaround**: Agent behavior and instructions are inlined into command prompts.

## Features Not Available

These Claude Code features cannot be replicated in Gemini CLI:

### 1. Model Selection per Command

Claude Code allows specifying `model: opus` or `model: haiku` for different tasks.

**Status**: Not possible in Gemini CLI.

### 2. Tool Restrictions

Claude Code agents can specify which tools they can access.

**Status**: Not possible in Gemini CLI. All tools are available to all commands.

### 3. Real-time Hook Processing

Claude Code hooks can modify tool inputs/outputs in real-time.

**Status**: Not possible in Gemini CLI.

### 4. Background Agents

Claude Code can spawn background agents (haiku) for analysis.

**Status**: Not possible in Gemini CLI.

### 5. Automatic Formatting on Edit

Claude Code PostToolUse hooks can auto-format files after editing.

**Status**: Not possible. Use manual formatting:
```bash
npx prettier --write <file>
```

### 6. Automatic Type Checking

Claude Code PostToolUse hooks can check TypeScript after editing.

**Status**: Not possible. Use manual checking:
```bash
npx tsc --noEmit
```

## Equivalent Capabilities

Despite limitations, equivalent results can be achieved:

| Capability | Claude Code Method | Gemini CLI Method |
|------------|-------------------|-------------------|
| Code formatting | PostToolUse hook | Manual: `npx prettier --write` |
| Type checking | PostToolUse hook | Manual: `npx tsc --noEmit` |
| Security scans | PreToolUse hook | Manual: grep for secrets |
| PR creation | Agent-assisted | Command-assisted |
| Code review | Dedicated agent | Inline in command |
| Test running | Agent with tools | Command with instructions |

## Recommendations

### For Best Results

1. **Run verification manually** - Use `/verify` command frequently
2. **Follow checklists** - GEMINI.md includes manual steps
3. **Create shell aliases** - Automate common tasks externally
4. **Use CI/CD** - Move automated checks to your CI pipeline

### Shell Aliases for Missing Features

```bash
# Add to .bashrc or .zshrc

# Auto-format after Gemini session
alias gfmt='npx prettier --write $(git diff --name-only --diff-filter=M "*.ts" "*.tsx" "*.js" "*.jsx")'

# Type check
alias gtype='npx tsc --noEmit'

# Security scan
alias gsec='grep -rn "sk-\|api_key\|password" --include="*.ts" --include="*.js" src/'

# Pre-commit check
alias gpre='gfmt && gtype && npm test'
```

## Future Improvements

As Gemini CLI evolves, feature parity may improve:

- [ ] Hook support expansion
- [ ] Agent-like subprocesses
- [ ] Model selection options
- [ ] Tool restriction capabilities

Monitor Gemini CLI releases for updates.
