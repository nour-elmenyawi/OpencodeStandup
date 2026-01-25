# Contributing to OpenCode Standup

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/opencode-standup.git
   cd opencode-standup
   ```
3. **Create a branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Setup

### Prerequisites

- OpenCode installed
- Git
- Bash shell (WSL, Linux, or macOS)

### Testing Your Changes

1. **Test the installation script:**
   ```bash
   ./install.sh
   ```

2. **Test the standup launcher:**
   ```bash
   cd /path/to/test/project
   standup
   ```

3. **Verify all agents launch correctly**

## Code Style

### Shell Scripts

- Use `#!/bin/bash` shebang
- Use `set -e` for error handling
- Add descriptive comments
- Use color codes for output (see existing scripts)
- Follow existing formatting style

### Skill Files (SKILL.md)

- Use clear markdown formatting
- Include examples where helpful
- Keep instructions concise
- Test with OpenCode before submitting

## Commit Messages

Follow conventional commit format:

- `feat: add new feature`
- `fix: resolve bug`
- `docs: update documentation`
- `refactor: improve code structure`
- `test: add tests`
- `chore: maintenance tasks`

Examples:
```
feat: add slack notification support
fix: resolve terminal launch issue on macOS
docs: update installation instructions
```

## Pull Request Process

1. **Update documentation** if needed
2. **Test your changes thoroughly**
3. **Create a pull request** with:
   - Clear description of changes
   - Why the change is needed
   - How to test the changes

4. **Wait for review** - maintainers will review your PR

## Areas for Contribution

We welcome contributions in these areas:

### Features

- [ ] Additional agent types (DevOps, Security, etc.)
- [ ] Slack/Discord integration
- [ ] Web dashboard for metrics
- [ ] Custom agent configurations
- [ ] CI/CD integration

### Improvements

- [ ] Better error handling
- [ ] Cross-platform support (macOS, Linux)
- [ ] Performance optimizations
- [ ] Better terminal detection

### Documentation

- [ ] Tutorial videos
- [ ] More examples
- [ ] Best practices guide
- [ ] FAQ expansion

### Bug Fixes

- Check [Issues](https://github.com/yourusername/opencode-standup/issues) for known bugs

## Testing

Before submitting a PR, test:

1. **Fresh installation** on a clean system (if possible)
2. **Multiple projects** to ensure isolation works
3. **All utility scripts** (metrics, summary, etc.)
4. **Edge cases** (no git repo, missing dependencies, etc.)

## Questions?

- Open an [Issue](https://github.com/yourusername/opencode-standup/issues)
- Join our [Discussions](https://github.com/yourusername/opencode-standup/discussions)

## Code of Conduct

- Be respectful and constructive
- Welcome newcomers
- Focus on what's best for the project
- Provide helpful feedback

Thank you for contributing! 🎉
