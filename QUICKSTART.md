# Quick Start Guide

Get up and running with OpenCode Standup in 5 minutes!

## Prerequisites Check

Before installing, make sure you have:

```bash
# Check OpenCode (required)
opencode --version

# Check Git (required)
git --version

# Check jq (optional, for metrics)
jq --version

# Check GitHub CLI (optional, for PR features)
gh --version
```

If OpenCode is missing:
```bash
curl -fsSL https://opencode.ai/install | bash
```

## Installation (3 steps)

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/opencode-standup.git
cd opencode-standup
```

### 2. Run the installer

```bash
./install.sh
```

The installer will:
- ✓ Install agent skills to `~/.opencode/skills/`
- ✓ Copy scripts to `~/.local/bin/`
- ✓ Check your PATH configuration

### 3. Update your PATH (if needed)

If the installer says your PATH needs updating, add this to `~/.zshrc` or `~/.bashrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then reload:
```bash
source ~/.zshrc  # or ~/.bashrc
```

## First Standup

### Navigate to a project

```bash
cd ~/my-project
```

### Add .standup/ to .gitignore

```bash
echo ".standup/" >> .gitignore
```

### Launch your AI team

```bash
standup
```

Four Windows Terminal windows will open!

## What Happens Next?

Each agent will:

1. **Load their skill** - Understanding their role
2. **Check notifications** - Look for urgent items
3. **Review progress** - Check yesterday's work
4. **Give standup update** - Report status

You'll interact with each agent to:
- Assign tasks
- Get updates
- Ask questions
- Review work

## Daily Workflow

### Morning

```bash
cd ~/my-project
standup
```

### Throughout the Day

Agents will:
- Update their progress files automatically
- Post notifications for important events
- Work on assigned tasks (with your guidance)

### End of Day

```bash
# Check team metrics
standup-metrics

# Generate summary
standup-summary
```

## Tips

### Multiple Projects

Each project is independent:

```bash
cd ~/project-a
standup  # Agents for project-a

cd ~/project-b
standup  # Different agents for project-b
```

### Resuming Sessions

Sessions persist! If you close a terminal:

```bash
cd ~/my-project
standup  # Resumes existing sessions for today
```

### Checking Progress

```bash
# View notifications
cat .standup/notifications.md

# View developer's log
cat .standup/developer/log-2024-01-25.md

# View tasks
cat .standup/developer/tasks.json | jq
```

## Common Commands

```bash
# Launch standup
standup

# View metrics
standup-metrics

# Generate summary
standup-summary

# Check PR status (needs gh CLI)
standup-pr-status

# Custom project name
standup --project-name my-app
```

## Troubleshooting

### Terminals don't open

1. Check Windows Terminal is installed
2. Try manual launch:
   ```bash
   cd .standup
   bash developer-wrapper.sh
   ```

### Command not found

```bash
# Add to PATH
export PATH="$HOME/.local/bin:$PATH"

# Then reload
source ~/.zshrc
```

### Skills not found

```bash
# Reinstall
cd opencode-standup
./install.sh
```

## Next Steps

- Read the [full README](README.md)
- Check [CONTRIBUTING.md](CONTRIBUTING.md) to contribute
- Report issues on GitHub

## Example Standup Conversation

**You:** Good morning! Let's start standup.

**Architect:** Good morning! Checking notifications... No urgent items. Yesterday I reviewed the authentication architecture and documented our decision to use JWT with refresh tokens. Today I'm planning to review the password reset flow design and ensure it follows security best practices. I recommend we use email-based password reset with time-limited tokens (15 min expiry). No blockers.

**Developer:** Good morning! Checking notifications... Noted architect's recommendation on JWT tokens. Yesterday I completed the user authentication feature using JWT as recommended and created unit tests. Today I'm planning to work on the password reset functionality following the architect's security guidelines. Any blockers? No blockers currently.

**QA:** Good morning! No urgent notifications. Yesterday I tested the authentication feature and found one minor UI issue (logged as bug #42). Today I'll continue testing and will start on the password reset feature once it's ready. No blockers.

**Code Reviewer:** Good morning! Checked notifications - all clear. Yesterday I reviewed PR #15 (authentication feature) and approved it after the developer addressed my feedback on error handling. Today I'll review any new PRs and focus on security review for the authentication system. No blockers.

**You:** Great! Architect, can you create a design doc for the password reset flow? Developer, please start on password reset implementation following architect's guidelines. QA, please verify bug #42 is logged correctly. Reviewer, let me know what you find in the security review.

---

**You're ready to go! Happy standup! 🚀**
