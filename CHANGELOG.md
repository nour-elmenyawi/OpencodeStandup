# Changelog

All notable changes to OpenCode Standup will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **Architect agent** (v1.1.0)
  - System architecture and design pattern guidance
  - Infrastructure and deployment recommendations
  - Best practices enforcement (SOLID, security, performance)
  - Technology stack guidance
  - Web hosting platform recommendations (AWS, Vercel, Railway, etc.)
  - Guides developer on architectural implementations
  - Maintains big picture and prevents technical debt

### Planned

- Slack/Discord integration for notifications
- Web dashboard for team metrics
- Support for custom agent configurations
- Additional agent types (DevOps, Security)
- CI/CD pipeline integration

## [1.0.0] - 2026-01-25

### Added

- **Four specialized AI agents**
  - Architect agent for system design and architecture guidance
  - Developer agent for implementing features and fixing bugs
  - QA Engineer agent for testing and quality assurance
  - Code Reviewer agent for code review and quality standards

- **Per-project isolation**
  - Each project gets its own `.standup/` directory
  - Independent progress tracking per project
  - Session naming: `<project>-<role>-<date>`

- **Automatic terminal management**
  - Launches 4 separate terminal windows (one per agent)
  - Cross-platform support: Windows Terminal (WSL), iTerm2/Terminal.app (macOS), GNOME Terminal/Konsole/xterm (Linux)
  - Persistent sessions that can be resumed
  - Wrapper scripts for reliable launching

- **Progress tracking system**
  - Daily narrative logs for each agent
  - Structured task tracking (JSON format)
  - Shared notification board for inter-agent communication

- **Utility scripts**
  - `standup` - Main launcher
  - `standup-metrics` - Team performance dashboard
  - `standup-summary` - Daily summary generator
  - `standup-pr-status` - PR status checker (GitHub CLI integration)

- **Smart installation**
  - Checks for existing skills before overwriting
  - Prompts user for updates to existing skills
  - Installs to `~/.local/bin` and `~/.opencode/skills`
  - Automatic dependency checking

- **Comprehensive documentation**
  - README with full feature documentation
  - Quick start guide for new users
  - Contributing guidelines
  - Troubleshooting section

- **Git integration**
  - Branch naming conventions
  - Commit message format
  - PR workflow with GitHub CLI

### Technical Details

- Written in Bash for cross-platform compatibility
- Uses OpenCode skills system for agent behavior
- JSON-based task tracking with jq support
- Color-coded terminal output
- Error handling and validation

### Files Included

- 4 agent skill files (architect, developer, qa-engineer, code-reviewer)
- 4 utility scripts (standup, metrics, summary, pr-status)
- Installation script with dependency checking
- MIT license
- Comprehensive documentation

[Unreleased]: https://github.com/yourusername/opencode-standup/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/yourusername/opencode-standup/releases/tag/v1.0.0
