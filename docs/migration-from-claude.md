# Migration from Claude Code

This guide helps users of everything-claude-code adapt to everything-gemini-cli.

## Key Differences

### 1. Command Format

**Claude Code** (Markdown with frontmatter):
```markdown
---
description: Restate requirements...
---
# Plan Command
This command invokes the **planner** agent...
```

**Gemini CLI** (TOML):
```toml
description = "Restate requirements..."

prompt = """
You are an expert planning specialist...
"""
```

### 2. Agent Handling

Claude Code has dedicated agents with tool restrictions. Gemini CLI does not support agents natively.

**Solution**: Agent behavior is inlined into command prompts. The detailed instructions from `agents/*.md` are embedded directly in the corresponding command TOML files.

### 3. Hooks

| Hook Type | Claude Code | Gemini CLI |
|-----------|-------------|------------|
| PreToolUse | Yes | No |
| PostToolUse | Yes | No |
| PreCompact | Yes | No |
| SessionStart | Yes | BeforeAgent (partial) |
| SessionEnd | Yes | No |
| Stop | Yes | No |

**Workaround**: Hook behaviors are documented as manual checklists in GEMINI.md.

### 4. Model Selection

Claude Code allows specifying models per agent/command (opus, sonnet, haiku). Gemini CLI uses a single model.

**Workaround**: Not applicable - adjust prompts as needed for Gemini's capabilities.

### 5. Skills Format

Skills use similar SKILL.md format in both systems. Minor adjustments:
- Remove Claude-specific frontmatter fields (`tools:`, `model:`)
- Ensure activation conditions work with Gemini CLI

## Migration Steps

### Step 1: Install Extension

```bash
gemini extensions install ./everything-gemini-cli
```

### Step 2: Verify Commands

```bash
# List available commands
gemini /help

# Test a command
gemini /plan "Test feature"
```

### Step 3: Load Skills (Experimental)

Skills are experimental in Gemini CLI:
```bash
# Enable experimental features
gemini config set experimental.skills true

# List skills
gemini /skills
```

### Step 4: Configure MCP Servers

Edit `gemini-extension.json` with your credentials:
```json
{
  "mcpServers": {
    "github": {
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your-actual-token"
      }
    }
  }
}
```

### Step 5: Review Manual Checklists

Since hooks aren't available, review GEMINI.md for manual checklists:
- Pre-commit checks
- Security review steps
- Code quality verification

## Equivalent Commands

| Claude Code | Gemini CLI | Notes |
|-------------|------------|-------|
| `/plan` | `/plan` | Same |
| `/tdd` | `/tdd` | Same |
| `/code-review` | `/code-review` | Agent behavior inlined |
| `/build-fix` | `/build-fix` | Same |
| `/e2e` | `/e2e` | Same |
| `/refactor-clean` | `/refactor-clean` | Same |
| `/checkpoint` | `/checkpoint` | Same |
| `/verify` | `/verify` | Same |
| `/learn` | `/learn` | Same |
| `/eval` | `/eval` | Same |
| `/orchestrate` | `/orchestrate` | Agent chaining simulated |

## Troubleshooting

### Commands not working

1. Verify extension is installed: `gemini extensions list`
2. Check TOML syntax in command files
3. Ensure `gemini-extension.json` is valid JSON

### Skills not loading

1. Enable experimental features
2. Check SKILL.md frontmatter format
3. Verify skill directory structure

### MCP servers not connecting

1. Verify credentials are correct
2. Check network connectivity
3. Ensure required packages are installed

## Getting Help

- File issues at the project repository
- Review Gemini CLI documentation
- Check the examples/ directory for reference configurations
