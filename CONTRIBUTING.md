# Contributing to The-Abyss

Thank you for your interest in contributing to The-Abyss, a Bash-based sysadmin toolbox for secure and efficient headless server management! We welcome help from the community to improve the project, especially through testing, bug reporting, and feature suggestions. This guide outlines how you can contribute effectively.

## How to Contribute

### 1. Reporting Bugs

We’re actively seeking testers to help identify and squash bugs in the current sysadmin toolbox. To report a bug:

- **Check Existing Issues**: Search the [Issues](https://github.com/LordSodomiser/The-Abyss/issues) page to avoid duplicates.
- **Create a New Issue**: Use the bug report template provided in the repository. Include:
  - A clear description of the bug.
  - Steps to reproduce it.
  - Expected vs. actual behavior.
  - Your environment (e.g., Linux distro, Bash version).
  - Screenshots or logs, if possible.
- **Be Specific**: Detailed reports help us address issues faster.

### 2. Suggesting Features

Have ideas for new tools or improvements? We’re planning features like Modular Dotfile Manager and TUI .onion Site Manager, but your input is valuable! To suggest a feature:

- Open a [new issue](https://github.com/LordSodomiser/The-Abyss/issues) using the feature request template.
- Describe the feature, its use case, and how it benefits sysadmins.
- Specify if it aligns with the project’s lightweight, zero-dependency philosophy.

### 3. Submitting Code

Want to contribute code or fixes? Awesome! Here’s how:

- **Fork the Repository**: Create your own fork of [The-Abyss](https://github.com/LordSodomiser/The-Abyss).
- **Clone and Branch**:
  ```bash
  git clone https://github.com/<your-username>/The-Abyss.git
  cd The-Abyss
  git checkout -b feature/your-feature-name
  ```
- **Make Changes**: Keep code lightweight, Bash-only, and compatible with headless Linux servers. Follow the existing script structure in `abyss-toolbox/`.
- **Test Thoroughly**: Ensure your changes work across common Linux distros.
- **Commit and Push**:
  ```bash
  git commit -m "Add feature/fix: brief description"
  git push origin feature/your-feature-name
  ```
- **Open a Pull Request**: Submit a PR with a clear title and description. Reference any related issues.

### 4. Testing the Toolbox

We need testers to ensure the toolbox is robust! To help:

- Download the latest release (v0.1.1) and follow the [README](README.md) Quick Start guide.
- Test on your Linux distro and report any issues via the bug report template.
- Verify script integrity using the provided SHA512 checksums or `verify` script.
- Share feedback on usability, performance, or potential improvements.

## Code of Conduct

- Be respectful and inclusive in all interactions.
- Provide constructive feedback and avoid personal attacks.
- Follow the project’s goal of maintaining a lightweight, secure, and efficient toolbox.

## Development Guidelines

- **Code Style**: Follow Bash best practices (e.g., use `#!/bin/bash`, avoid external dependencies).
- **Documentation**: Update relevant documentation (e.g., README, inline comments) with your changes.
- **Testing**: Ensure scripts run on major Linux distros (e.g., Ubuntu, Debian, Arch).
- **Licensing**: Contributions are licensed under the MIT License, matching the project.

## Questions?

Have questions or need help? Open an issue or join our community discussion (details in the README). Your contributions, big or small, help make The-Abyss a better tool for sysadmins everywhere!