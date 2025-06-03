# Contributing to TdLib Universal Installer

Thank you for your interest in contributing to the TdLib Universal Installer! We welcome contributions from the community and are grateful for your support.

## 🤝 How to Contribute

### Reporting Issues

If you encounter any problems or have suggestions for improvements:

1. **Search existing issues** to avoid duplicates
2. **Create a new issue** with a clear title and description
3. **Include system information**:
   - Operating system and version
   - Architecture (x86_64, ARM64, etc.)
   - Error messages or logs
   - Steps to reproduce the issue

### Submitting Pull Requests

1. **Fork the repository** and create your feature branch:
   ```bash
   git checkout -b feature/amazing-feature
   ```

2. **Make your changes** following our coding standards:
   - Use clear, descriptive commit messages
   - Follow existing code style and conventions
   - Add comments for complex logic
   - Test your changes on multiple platforms if possible

3. **Test thoroughly**:
   ```bash
   ./install.sh --verify-only  # Test existing functionality
   ./install.sh --force        # Test clean installation
   ```

4. **Submit your pull request** with:
   - Clear description of changes
   - Reference to related issues
   - Testing information

## 🧪 Testing Guidelines

### Platform Testing

We aim to support multiple platforms. When contributing, please test on:

- **Linux**: Ubuntu/Debian, CentOS/RHEL, Arch Linux
- **macOS**: Latest 2-3 versions
- **Windows**: WSL environments

### Test Cases

- Fresh installation on clean system
- Reinstallation over existing installation
- Dependency handling
- Error recovery scenarios

## 📝 Code Style

### Shell Script Guidelines

- Use `#!/bin/bash` shebang
- Enable strict mode: `set -e` and `set -u`
- Use meaningful variable names
- Quote variables to prevent word splitting
- Use functions for reusable code
- Add error handling for critical operations

### Documentation

- Update README.md for new features
- Add inline comments for complex logic
- Include usage examples
- Update help text if adding new options

## 🚀 Development Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/DeepPythonist/TDLIB-installer.git
   cd TDLIB-installer
   ```

2. **Make the script executable**:
   ```bash
   chmod +x install.sh
   ```

3. **Test your changes**:
   ```bash
   ./install.sh --help
   ./install.sh --verify-only
   ```

## 🐛 Debugging

### Enable Debug Mode

Add debug output to your changes:
```bash
set -x  # Enable debug mode
# Your code here
set +x  # Disable debug mode
```

### Common Issues

- **Permission errors**: Ensure proper sudo usage
- **Path issues**: Use absolute paths where necessary
- **Platform detection**: Test on different distributions
- **Dependency conflicts**: Handle existing installations gracefully

## 📋 Checklist

Before submitting your contribution:

- [ ] Code follows project style guidelines
- [ ] Changes are tested on relevant platforms
- [ ] Documentation is updated
- [ ] Commit messages are clear and descriptive
- [ ] No sensitive information is included
- [ ] License headers are preserved

## 🎯 Priority Areas

We especially welcome contributions in these areas:

- **Platform support**: Adding support for new Linux distributions
- **Error handling**: Improving error messages and recovery
- **Performance**: Optimizing build times and resource usage
- **Documentation**: Improving guides and troubleshooting
- **Testing**: Adding automated tests and CI/CD

## 📞 Getting Help

If you need help with your contribution:

- **Open a discussion** on GitHub
- **Reference existing issues** for similar problems
- **Ask questions** in your pull request

## 🙏 Recognition

All contributors will be recognized in our README.md file. We appreciate every contribution, no matter how small!

---

Thank you for helping make TdLib more accessible to developers worldwide! 🚀 