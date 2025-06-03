# Changelog

All notable changes to the TdLib Universal Installer will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-XX

### Added
- Initial release of TdLib Universal Installer
- Cross-platform support for Linux, macOS, and Windows
- Automatic platform detection and dependency management
- macOS atomic operations fix for Apple Clang compatibility
- Parallel compilation using all available CPU cores
- Colored logging with progress indicators
- Installation verification system
- Command-line options for different installation modes
- Comprehensive error handling and recovery mechanisms

### Features
- **Platform Support**:
  - Ubuntu/Debian with apt package manager
  - CentOS/RHEL with yum package manager
  - Arch Linux with pacman package manager
  - macOS with Homebrew and Xcode Command Line Tools
  - Windows with WSL recommendation

- **Installation Options**:
  - `--force`: Clean reinstallation
  - `--skip-deps`: Skip dependency installation
  - `--verify-only`: Verify existing installation
  - `--help`: Show usage information

- **Automatic Fixes**:
  - macOS atomic operations compatibility
  - Command Line Tools installation and updates
  - SDK path detection and configuration

### Technical Details
- Built with Bash for maximum compatibility
- Supports x86_64, ARM64, and ARM32 architectures
- Automatic CMake configuration based on platform
- Comprehensive dependency management
- Error recovery and cleanup mechanisms

---

## Future Releases

### Planned Features
- [ ] Automated testing and CI/CD integration
- [ ] Support for additional Linux distributions
- [ ] Windows native support (without WSL)
- [ ] Docker container support
- [ ] Version selection for TdLib builds
- [ ] Custom build configuration options

### Known Issues
- Windows native support requires manual setup
- Some older Linux distributions may need manual dependency installation

---

*For detailed information about each release, see the [GitHub Releases](https://github.com/DeepPythonist/TDLIB-installer/releases) page.* 