# TdLib Universal Installer

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform Support](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows-blue.svg)](https://github.com/DeepPythonist/TDLIB-installer)
[![Build Status](https://img.shields.io/badge/Build-Automated-green.svg)](https://github.com/DeepPythonist/TDLIB-installer)

🚀 **A comprehensive and reliable installation script for TdLib (Telegram Database Library) across all major platforms**

This script automatically downloads, compiles, and installs TdLib with zero configuration required. Designed to work seamlessly on Linux, macOS, and Windows platforms with intelligent platform detection and automatic dependency management.

## ✨ Features

- 🔍 **Automatic Platform Detection**: Supports Ubuntu/Debian, CentOS/RHEL, Arch Linux, macOS, and Windows
- 📦 **Dependency Management**: Automatically installs all required build tools and libraries
- 🔧 **Platform-Specific Fixes**: Resolves known issues like macOS atomic operations automatically
- ✅ **Installation Verification**: Validates successful compilation and library creation
- 🎨 **Rich Output**: Colored logging with clear progress indicators
- ⚡ **Parallel Compilation**: Utilizes all available CPU cores for faster builds
- 🛡️ **Error Handling**: Comprehensive error detection and recovery mechanisms

## 🚀 Quick Start

### One-Command Installation
```bash
curl -fsSL https://raw.githubusercontent.com/DeepPythonist/TDLIB-installer/main/install.sh | bash
```

### Manual Installation
```bash
git clone https://github.com/DeepPythonist/TDLIB-installer.git
cd TDLIB-installer
chmod +x install.sh
./install.sh
```

## 📋 Usage Options

```bash
# Standard installation
./install.sh

# Force clean reinstallation
./install.sh --force

# Skip dependency installation (if already installed)
./install.sh --skip-deps

# Verify existing installation only
./install.sh --verify-only

# Show help
./install.sh --help
```

## 🔧 Platform Requirements

### Linux (Ubuntu/Debian)
- `build-essential`, `cmake`, `git`, `libssl-dev`, `zlib1g-dev`
- Automatically installed by the script

### Linux (CentOS/RHEL)
- Development Tools, `cmake`, `git`, `openssl-devel`, `zlib-devel`
- Automatically installed by the script

### macOS
- Xcode Command Line Tools (automatically installed)
- Homebrew (automatically installed if needed)

### Windows
- Visual Studio 2019+ with C++ support
- CMake and Git
- **Recommended**: Use WSL (Windows Subsystem for Linux)

## 🐍 Python Integration

After successful installation, integrate TdLib into your Python projects:

```python
import os
import ctypes
import json

# Load TdLib
tdjson_path = os.path.abspath('td/build/libtdjson.dylib')  # macOS
# tdjson_path = os.path.abspath('td/build/libtdjson.so')   # Linux

tdjson = ctypes.CDLL(tdjson_path)

# Configure function signatures
tdjson.td_json_client_create.restype = ctypes.c_void_p
tdjson.td_json_client_send.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
tdjson.td_json_client_receive.argtypes = [ctypes.c_void_p, ctypes.c_double]
tdjson.td_json_client_receive.restype = ctypes.c_char_p

# Create client and start using TdLib
client = tdjson.td_json_client_create()
```

## 🏗️ Build Output

After successful installation, you'll find:

```
td/
├── build/
│   ├── libtdjson.dylib    # macOS dynamic library
│   ├── libtdjson.so       # Linux dynamic library
│   └── libtdjson.a        # Static library (all platforms)
└── ...
```

## 🔍 Troubleshooting

### macOS Issues
The script automatically handles common macOS compilation issues:
- **Atomic Operations**: Automatically patched for Apple Clang compatibility
- **Command Line Tools**: Auto-installation and updates
- **SDK Path**: Automatic detection and configuration

### Linux Issues
- **Missing Dependencies**: Automatically detected and installed
- **Compiler Compatibility**: Supports GCC and Clang
- **Architecture Support**: x86_64, ARM64, and ARM32

### General Issues
```bash
# Verify installation
./install.sh --verify-only

# Clean reinstall
./install.sh --force

# Check logs for detailed error information
```

## 🌍 Platform Support Matrix

| Platform | Status | Notes |
|----------|--------|-------|
| Ubuntu 18.04+ | ✅ | Fully supported |
| Debian 10+ | ✅ | Fully supported |
| CentOS 7+ | ✅ | Fully supported |
| RHEL 7+ | ✅ | Fully supported |
| Arch Linux | ✅ | Fully supported |
| macOS 10.15+ | ✅ | With automatic fixes |
| Windows 10+ | ⚠️ | Recommended: WSL |

## 📚 Documentation & Resources

- [TdLib Official Documentation](https://core.telegram.org/tdlib)
- [TdLib GitHub Repository](https://github.com/tdlib/td)
- [Python Examples](https://github.com/tdlib/td/tree/master/example/python)
- [API Methods Reference](https://core.telegram.org/tdlib/docs/)

## 🤝 Contributing

We welcome contributions! Please feel free to submit issues, feature requests, or pull requests.

### Development Setup
```bash
git clone https://github.com/DeepPythonist/TDLIB-installer.git
cd TDLIB-installer
# Make your changes
./install.sh --verify-only  # Test your changes
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [TdLib Team](https://github.com/tdlib/td) for creating the excellent Telegram Database Library
- Community contributors for testing and feedback across different platforms

---

**Made with ❤️ for the developer community**

*For support, please open an issue on GitHub or check our troubleshooting guide above.* 