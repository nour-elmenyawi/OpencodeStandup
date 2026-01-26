# OpenCode Standup

> AI-powered standup meetings for your development team

Automate your daily standups with four specialized AI agents that work together to manage architecture, development, QA, and code review tasks across all your projects.

![OpenCode Standup Demo](https://via.placeholder.com/800x400?text=OpenCode+Standup+Demo)

## Features

- 🤖 **Four Specialized AI Agents**
  - **Architect** - Designs system architecture, ensures best practices, and guides technical decisions
  - **Developer** - Implements features and fixes bugs
  - **QA Engineer** - Tests features and identifies issues
  - **Code Reviewer** - Reviews code quality and suggests improvements

- 📊 **Progress Tracking**
  - Daily narrative logs for each agent
  - Structured task tracking (JSON)
  - Shared notification system

- 🚀 **Per-Project Isolation**
  - Each project gets its own agent team
  - Progress files stay in project directory
  - Independent sessions per project

- 💻 **Automatic Terminal Management**
  - Launches 4 separate terminal windows automatically
  - Supports Windows Terminal (WSL), iTerm2/Terminal.app (macOS), and GNOME Terminal/Konsole/xterm (Linux)
  - Persistent sessions (resume anytime)
  - Session naming: `<project>-<role>-<date>`

- 📈 **Built-in Metrics & Reporting**
  - View team performance metrics
  - Generate daily summaries
  - Check PR status (with GitHub CLI)

## Requirements

- [OpenCode](https://opencode.ai) - AI coding assistant
- Git
- Terminal emulator (platform-specific):
  - **Windows (WSL):** Windows Terminal
  - **macOS:** iTerm2 or Terminal.app (built-in)
  - **Linux:** GNOME Terminal, Konsole, or xterm
- `jq` (optional, for metrics)
- `gh` GitHub CLI (optional, for PR features)

## Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/opencode-standup.git
cd opencode-standup

# Run the installer
./install.sh
```

The installer will:
1. Check dependencies
2. Install AI agent skills to `~/.opencode/skills/`
3. Install scripts to `~/.local/bin/`
4. Configure your PATH (if needed)

### Usage

```bash
# Navigate to any project
cd ~/my-project

# Launch your AI standup team
standup
```

Four terminal windows will open, each with an agent ready to provide their standup update.

**Platform Notes:**
- **Windows/WSL:** Opens new Windows Terminal windows
- **macOS:** Opens new iTerm2 windows (or Terminal.app if iTerm2 not installed)
- **Linux:** Opens new GNOME Terminal, Konsole, or xterm windows (whichever is available)

## How It Works

### 1. Per-Project Setup

Each project gets its own `.standup/` directory:

```
~/my-project/
├── .standup/
│   ├── notifications.md          # Shared notifications
│   ├── architect/
│   │   ├── log-2024-01-25.md    # Daily log
│   │   └── tasks.json            # Task tracking
│   ├── developer/
│   │   ├── log-2024-01-25.md    # Daily log
│   │   └── tasks.json            # Task tracking
│   ├── qa-engineer/
│   │   ├── log-2024-01-25.md
│   │   └── tasks.json
│   └── code-reviewer/
│       ├── log-2024-01-25.md
│       └── tasks.json
```

**Important:** Add `.standup/` to your project's `.gitignore`:

```bash
echo ".standup/" >> .gitignore
```

### 2. Agent Workflow

Each agent follows this workflow:

1. **Morning Standup**
   - Load their specialized skill
   - Check notifications for urgent items
   - Review yesterday's progress
   - Provide standup update

2. **Throughout the Day**
   - Work on assigned tasks
   - Update progress files automatically
   - Post notifications for important events
   - Check for new notifications periodically

3. **Communication**
   - Agents communicate via `.standup/notifications.md`
   - Priority levels: 🔴 URGENT, 🟡 IMPORTANT, 🟢 FYI
   - Cross-agent collaboration on tasks

### 3. Multiple Projects

Run standup in different projects - each gets isolated agents:

```bash
# Project 1
cd ~/trading-cards-app
standup
# Sessions: trading-cards-app-developer-2024-01-25, etc.

# Project 2
cd ~/another-project
standup
# Sessions: another-project-developer-2024-01-25, etc.
```

## Available Commands

| Command | Description |
|---------|-------------|
| `standup` | Launch all four agents in separate windows |
| `standup-metrics` | View team performance dashboard |
| `standup-summary` | Generate daily summary report |
| `standup-pr-status` | Check PR status (requires `gh` CLI) |

### Command Examples

```bash
# Launch standup with custom project name
standup --project-name my-app

# View team metrics
standup-metrics

# Generate summary for specific date
standup-summary --date 2024-01-20

# Check PR status
standup-pr-status
```

## Agent Capabilities

### Architect Agent

**Responsibilities:**
- Design system architecture and infrastructure
- Ensure industry-standard design patterns are followed
- Guide technical decisions on scalability, security, and maintainability
- Direct developer on architectural implementations
- Review technical decisions and propose improvements
- Document architecture decisions and rationale
- Identify and address technical debt

**Skills:**
- System design and architecture patterns
- Infrastructure and deployment strategies (AWS, Vercel, Railway, etc.)
- Best practices (SOLID, security, performance, scalability)
- Technology stack guidance
- Code organization and project structure
- Web hosting and cloud platform recommendations

**Key Focus:**
- Maintains the big picture of the project
- Guides developer with architectural wisdom
- Ensures scalable and maintainable solutions
- Prevents technical debt before it accumulates

### Developer Agent

**Responsibilities:**
- Implement new features
- Fix bugs and issues
- Refactor code
- Create unit tests
- Update documentation

**Skills:**
- Code implementation
- Debugging
- Git workflow
- Test writing

### QA Engineer Agent

**Responsibilities:**
- Test new features
- Create test plans
- Identify bugs
- Regression testing
- Performance testing

**Skills:**
- Manual testing
- Test automation
- Bug reporting
- Quality metrics

### Code Reviewer Agent

**Responsibilities:**
- Review pull requests
- Ensure code quality
- Check best practices
- Suggest improvements
- Approve/reject changes

**Skills:**
- Code analysis
- Security review
- Performance review
- Architecture review

## Configuration

### Customizing Agents

Agent skills are located in `~/.opencode/skills/`:

```bash
~/.opencode/skills/
├── developer/
│   └── SKILL.md
├── qa-engineer/
│   └── SKILL.md
└── code-reviewer/
    └── SKILL.md
```

Edit these files to customize agent behavior.

### Session Naming

Sessions are automatically named: `<project>-<role>-<date>`

Override project name:
```bash
standup --project-name custom-name
```

## Troubleshooting

### Terminals Not Opening

If Windows Terminal windows don't open:

1. **Check if `wt.exe` is available:**
   ```bash
   which wt.exe
   ```

2. **Try manual launch:**
   ```bash
   cd .standup
   bash developer-wrapper.sh
   ```

3. **Check Windows Terminal is installed** in Windows

### Skills Not Found

If agents can't find their skills:

1. **Reinstall skills:**
   ```bash
   cd opencode-standup
   ./install.sh
   ```

2. **Verify skills exist:**
   ```bash
   ls ~/.opencode/skills/
   ```

### Command Not Found

If `standup` command isn't found:

1. **Check PATH:**
   ```bash
   echo $PATH | grep ".local/bin"
   ```

2. **Add to PATH manually** (add to `~/.zshrc` or `~/.bashrc`):
   ```bash
   export PATH="$HOME/.local/bin:$PATH"
   ```

3. **Reload shell:**
   ```bash
   source ~/.zshrc  # or ~/.bashrc
   ```

## Development

### Project Structure

```
opencode-standup/
├── bin/                    # Scripts
│   ├── standup            # Main launcher
│   ├── standup-metrics    # Metrics dashboard
│   ├── standup-pr-status  # PR status checker
│   └── standup-summary    # Summary generator
├── skills/                 # Agent skills
│   ├── developer/
│   ├── qa-engineer/
│   └── code-reviewer/
├── install.sh             # Installation script
├── README.md
├── LICENSE
└── .gitignore
```

### Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Roadmap

- [ ] Support for custom agent configurations
- [ ] Slack integration for notifications
- [ ] Web dashboard for team metrics
- [ ] Support for additional agents (DevOps, Security, etc.)
- [ ] Integration with project management tools
- [ ] CI/CD pipeline integration

## FAQ

**Q: Do the agents run in the background?**  
A: No, agents are conversational and require your interaction. They maintain context through session persistence.

**Q: Can I use this with non-Git projects?**  
A: Yes, but some features (like PR status) won't work. The `.standup/` directory will be created in your current directory.

**Q: How much does this cost?**  
A: The tool is free and open-source. OpenCode usage is subject to their pricing.

**Q: Can I customize the agents?**  
A: Yes! Edit the skill files in `~/.opencode/skills/` to customize agent behavior.

**Q: Will agents make commits automatically?**  
A: No, agents only commit when you explicitly ask them to.

## License

MIT License - see [LICENSE](LICENSE) file for details

## Acknowledgments

- Built with [OpenCode](https://opencode.ai)
- Inspired by agile standup meetings
- Community contributions welcome

---

**Made with ❤️ for developers who want AI teammates**

[Report Bug](https://github.com/yourusername/opencode-standup/issues) · [Request Feature](https://github.com/yourusername/opencode-standup/issues) · [Documentation](https://github.com/yourusername/opencode-standup/wiki)
