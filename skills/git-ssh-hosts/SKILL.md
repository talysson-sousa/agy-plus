---
name: git-ssh-hosts
description: >
  Guidance and rules for working with multiple GitHub SSH identities and host aliases
  configured on this workstation (specifically githubMandarin for Agencia-Mandarin vs github.com).
  Activate whenever setting git remotes, cloning, pushing, pulling, or troubleshooting
  "Repository not found" or "Permission denied (publickey)" errors.
metadata:
  version: 1.0.0
---

# Git Multi-Host & SSH Identities Guide

This workstation manages multiple GitHub accounts via SSH aliases defined in `~/.ssh/config`.

## Configured Host Aliases

| Host Alias | HostName | Identity Key | Authenticated User | Scope / Organizations |
|---|---|---|---|---|
| **`githubMandarin`** | `github.com` | `~/.ssh/mandarin` | `talysson-sousa` | Repositories under **`Agencia-Mandarin/*`** |
| **`github`** / default | `github.com` | `~/.ssh/id_ed25519` | `talysson-andrade` | Personal repositories / Public repos |

---

## Automatic Selection Rules

### 1. Repositories in `Agencia-Mandarin`
Whenever working with any repository owned by `Agencia-Mandarin` (e.g. `Agencia-Mandarin/<repo>`):
- **ALWAYS** use the host alias `githubMandarin` instead of `github.com` in Git SSH URLs:
  ```bash
  # Remote configuration
  git remote add origin git@githubMandarin:Agencia-Mandarin/<repo>.git
  # Or updating existing remote
  git remote set-url origin git@githubMandarin:Agencia-Mandarin/<repo>.git
  # Cloning
  git clone git@githubMandarin:Agencia-Mandarin/<repo>.git
  ```

### 2. Personal & External Repositories
For personal repositories or general open-source repositories:
- Use standard `git@github.com:<user>/<repo>.git` or `git@github:<user>/<repo>.git`.

---

## Troubleshooting "Repository Not Found"

If Git operations fail with:
```
ERROR: Repository not found.
fatal: Could not read from remote repository.
Please make sure you have the correct access rights and the repository exists.
```

### Diagnostic Steps:
1. Check current remote URL:
   ```bash
   git remote -v
   ```
2. Test SSH identity connection:
   ```bash
   ssh -T git@githubMandarin  # Should greet: "Hi talysson-sousa!"
   ssh -T git@github.com       # Should greet: "Hi talysson-andrade!"
   ```
3. If the repository belongs to `Agencia-Mandarin`, switch the remote URL to `githubMandarin`:
   ```bash
   git remote set-url origin git@githubMandarin:Agencia-Mandarin/<repo>.git
   ```
