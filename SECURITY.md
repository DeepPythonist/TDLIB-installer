# Security Policy

## Supported Versions

We actively support the following versions of TdLib Universal Installer:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability in the TdLib Universal Installer, please report it responsibly.

### How to Report

1. **DO NOT** create a public GitHub issue for security vulnerabilities
2. **Email us directly** at: mrasolesfandiari@gmail.com
3. **Include the following information**:
   - Description of the vulnerability
   - Steps to reproduce the issue
   - Potential impact
   - Suggested fix (if any)

### What to Expect

- **Acknowledgment**: We will acknowledge receipt of your report within 48 hours
- **Investigation**: We will investigate and validate the vulnerability
- **Timeline**: We aim to provide an initial response within 5 business days
- **Resolution**: Critical vulnerabilities will be addressed within 30 days

### Security Considerations

The TdLib Universal Installer performs the following potentially sensitive operations:

- **System package installation** (requires sudo privileges)
- **File system modifications** (creates directories and files)
- **Network requests** (downloads source code from GitHub)
- **Compilation** (executes build tools)

### Best Practices for Users

1. **Review the script** before running it on your system
2. **Run in a controlled environment** (VM or container) for testing
3. **Keep your system updated** with latest security patches
4. **Use official sources** only - download from the official repository

### Scope

This security policy covers:

- The main installation script (`install.sh`)
- Documentation and examples
- GitHub Actions workflows
- Any auxiliary scripts or tools

### Out of Scope

- Third-party dependencies (TdLib itself, system packages)
- User's system configuration
- Network security during downloads

## Security Updates

Security updates will be:

- Released as patch versions (e.g., 1.0.1)
- Documented in the CHANGELOG.md
- Announced in GitHub releases
- Tagged with security labels

## Contact

For security-related questions or concerns:

- **Security issues**: mrasolesfandiari@gmail.com
- **General questions**: Create a GitHub issue
- **Discussions**: Use GitHub Discussions

---

Thank you for helping keep TdLib Universal Installer secure! 🔒 