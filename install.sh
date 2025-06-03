#!/bin/bash

# TdLib Universal Installer
# 
# A comprehensive and reliable installation script for TdLib (Telegram Database Library)
# across all major platforms with automatic dependency management and platform-specific fixes.
#
# Repository: https://github.com/DeepPythonist/TDLIB-installer
# Author: DeepPythonist
# License: MIT
# Version: 1.0.0
#
# Supported Platforms:
# - Linux (Ubuntu/Debian, CentOS/RHEL, Arch Linux)
# - macOS (with automatic Xcode Command Line Tools setup)
# - Windows (via WSL - Windows Subsystem for Linux)
#
# Features:
# - Automatic platform detection and dependency installation
# - macOS atomic operations fix for Apple Clang compatibility
# - Parallel compilation using all available CPU cores
# - Comprehensive error handling and installation verification
# - Colored logging with clear progress indicators

set -e  # Exit on any error
set -u  # Exit on undefined variables

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Error handler
error_exit() {
    log_error "$1"
    exit 1
}

# Platform detection
detect_platform() {
    local os_name=$(uname -s)
    local arch=$(uname -m)
    
    case "$os_name" in
        Linux*)
            PLATFORM="linux"
            if command -v apt-get >/dev/null 2>&1; then
                DISTRO="debian"
            elif command -v yum >/dev/null 2>&1; then
                DISTRO="redhat"
            elif command -v pacman >/dev/null 2>&1; then
                DISTRO="arch"
            else
                DISTRO="unknown"
            fi
            ;;
        Darwin*)
            PLATFORM="macos"
            DISTRO="macos"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            PLATFORM="windows"
            DISTRO="windows"
            ;;
        *)
            error_exit "Unsupported operating system: $os_name"
            ;;
    esac
    
    case "$arch" in
        x86_64|amd64)
            ARCH="x64"
            ;;
        arm64|aarch64)
            ARCH="arm64"
            ;;
        armv7l)
            ARCH="arm"
            ;;
        *)
            log_warning "Unknown architecture: $arch, assuming x64"
            ARCH="x64"
            ;;
    esac
    
    log_info "Detected platform: $PLATFORM ($DISTRO) - $ARCH"
}

# Install dependencies based on platform
install_dependencies() {
    log_info "Installing dependencies for $PLATFORM ($DISTRO)..."
    
    case "$DISTRO" in
        debian)
            sudo apt-get update
            sudo apt-get install -y \
                build-essential \
                cmake \
                git \
                gperf \
                libssl-dev \
                libc++-dev \
                libc++abi-dev \
                zlib1g-dev \
                wget \
                curl
            ;;
        redhat)
            sudo yum groupinstall -y "Development Tools"
            sudo yum install -y \
                cmake \
                git \
                gperf \
                openssl-devel \
                zlib-devel \
                wget \
                curl
            ;;
        arch)
            sudo pacman -Syu --noconfirm
            sudo pacman -S --noconfirm \
                base-devel \
                cmake \
                git \
                gperf \
                openssl \
                zlib \
                wget \
                curl
            ;;
        macos)
            # Check if Homebrew is installed
            if ! command -v brew >/dev/null 2>&1; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            
            # Update Homebrew
            brew update
            
            # Install dependencies
            brew install cmake git gperf openssl zlib wget curl
            
            # Install Xcode Command Line Tools if not present
            if ! xcode-select -p >/dev/null 2>&1; then
                log_info "Installing Xcode Command Line Tools..."
                xcode-select --install
                log_warning "Please complete the Xcode Command Line Tools installation and run this script again."
                exit 1
            fi
            
            # Update Command Line Tools if needed
            if softwareupdate --list 2>/dev/null | grep -q "Command Line Tools"; then
                log_info "Updating Command Line Tools..."
                sudo softwareupdate --install --all
            fi
            ;;
        windows)
            log_info "For Windows, please ensure you have:"
            log_info "- Visual Studio 2019 or later with C++ support"
            log_info "- CMake (https://cmake.org/download/)"
            log_info "- Git (https://git-scm.com/download/win)"
            log_warning "This script is designed for Unix-like systems. For Windows, consider using WSL."
            ;;
        *)
            log_warning "Unknown distribution. Please install the following manually:"
            log_warning "- C++ compiler (gcc/clang)"
            log_warning "- CMake (3.5 or later)"
            log_warning "- Git"
            log_warning "- OpenSSL development libraries"
            log_warning "- zlib development libraries"
            ;;
    esac
    
    log_success "Dependencies installation completed"
}

# Download TdLib source code
download_tdlib() {
    local tdlib_dir="td"
    local tdlib_url="https://github.com/tdlib/td.git"
    
    log_info "Downloading TdLib source code..."
    
    if [ -d "$tdlib_dir" ]; then
        log_info "TdLib directory exists, updating..."
        cd "$tdlib_dir"
        git fetch origin
        git reset --hard origin/master
        cd ..
    else
        log_info "Cloning TdLib repository..."
        git clone "$tdlib_url" "$tdlib_dir"
    fi
    
    log_success "TdLib source code downloaded"
}

# Fix macOS atomic operations issue
fix_macos_atomics() {
    if [ "$PLATFORM" = "macos" ]; then
        log_info "Applying macOS atomic operations fix..."
        
        local atomics_file="td/CMake/FindAtomics.cmake"
        
        if [ -f "$atomics_file" ]; then
            # Create backup
            cp "$atomics_file" "${atomics_file}.backup"
            
            # Apply fix for macOS
            cat > "$atomics_file" << 'EOF'
# Original issue:
# * https://gitlab.kitware.com/cmake/cmake/-/issues/23021#note_1098733
#
# For reference:
# * https://gcc.gnu.org/wiki/Atomic/GCCMM
#
# riscv64 specific:
# * https://lists.debian.org/debian-riscv/2022/01/msg00009.html
#
# ATOMICS_FOUND         - system has C++ atomics
# ATOMICS_LIBRARIES     - libraries needed to use C++ atomics

if (ATOMICS_FOUND)
  return()
endif()

# Special handling for macOS/Apple - atomics are built into the standard library
if (APPLE)
  set(ATOMICS_FOUND TRUE CACHE BOOL "Atomic operations found" FORCE)
  set(ATOMICS_LIBRARIES "" CACHE STRING "Atomic operations library" FORCE)
  message(STATUS "Found atomics: built into Apple standard library")
  return()
endif()

include(CheckCXXSourceCompiles)

# RISC-V only has 32-bit and 64-bit atomic instructions. GCC is supposed
# to convert smaller atomics to those larger ones via masking and
# shifting like LLVM, but it's a known bug that it does not. This means
# anything that wants to use atomics on 1-byte or 2-byte types needs
# to link atomic library, but not 4-byte or 8-byte (though it doesn't
# hurt to link it in that case too).

# First, check if atomics work without the library.
# If not, check if the library exists, and if so, try with the library.
set(CMAKE_REQUIRED_QUIET_SAVE ${CMAKE_REQUIRED_QUIET})
set(CMAKE_REQUIRED_QUIET ON)

# std::atomic<uint64_t> in some configurations requires linking to
# libatomic. We can represent this as this simply being required,
# regardless of the underlying platform. In reality, this is also
# true on some other platforms.
check_cxx_source_compiles("
#include <atomic>
#include <cstdint>
std::atomic<std::uint8_t> n8 {0}; // riscv64
std::atomic<std::uint64_t> n64 {0}; // armel, mipsel, powerpc
int main() {
  ++n8;
  ++n64;
  return 0;
}
" ATOMICS_LOCK_FREE_INSTRUCTIONS)

if (ATOMICS_LOCK_FREE_INSTRUCTIONS)
  set(ATOMICS_FOUND TRUE CACHE BOOL "Atomic operations found")
  set(ATOMICS_LIBRARIES "" CACHE STRING "Atomic operations library")
else()
  set(CMAKE_REQUIRED_LIBRARIES "-latomic")
  check_cxx_source_compiles("
#include <atomic>
#include <cstdint>
std::atomic<std::uint8_t> n8 {0}; // riscv64
std::atomic<std::uint64_t> n64 {0}; // armel, mipsel, powerpc
int main() {
  ++n8;
  ++n64;
  return 0;
}
" ATOMICS_IN_LIBRARY)
  set(CMAKE_REQUIRED_LIBRARIES)

  if (ATOMICS_IN_LIBRARY)
    set(ATOMICS_FOUND TRUE CACHE BOOL "Atomic operations found")
    set(ATOMICS_LIBRARIES "-latomic" CACHE STRING "Atomic operations library")
  else()
    set(ATOMICS_FOUND FALSE CACHE BOOL "Atomic operations found")
    set(ATOMICS_LIBRARIES "" CACHE STRING "Atomic operations library")
  endif()
endif()

set(CMAKE_REQUIRED_QUIET ${CMAKE_REQUIRED_QUIET_SAVE})

if (ATOMICS_FOUND)
  message(STATUS "Found atomics: ${ATOMICS_LIBRARIES}")
else()
  message(STATUS "Atomics not found")
endif()
EOF
            
            log_success "macOS atomic operations fix applied"
        fi
    fi
}

# Build TdLib
build_tdlib() {
    log_info "Building TdLib..."
    
    cd td
    
    # Create build directory
    if [ -d "build" ]; then
        log_info "Cleaning existing build directory..."
        rm -rf build
    fi
    
    mkdir build
    cd build
    
    # Configure CMake based on platform
    local cmake_args="-DCMAKE_BUILD_TYPE=Release"
    
    case "$PLATFORM" in
        macos)
            # Use the system SDK for macOS
            local sdk_path=$(xcrun --show-sdk-path 2>/dev/null || echo "")
            if [ -n "$sdk_path" ]; then
                cmake_args="$cmake_args -DCMAKE_OSX_SYSROOT=$sdk_path"
            fi
            ;;
        linux)
            # Add any Linux-specific flags if needed
            cmake_args="$cmake_args -DCMAKE_CXX_STANDARD=17"
            ;;
    esac
    
    log_info "Configuring CMake with: $cmake_args"
    cmake $cmake_args ..
    
    # Build the tdjson target
    log_info "Building tdjson library..."
    local cpu_count=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo "4")
    make tdjson -j"$cpu_count"
    
    cd ../..
    
    log_success "TdLib build completed"
}

# Verify installation
verify_installation() {
    log_info "Verifying TdLib installation..."
    
    local lib_extensions=("dylib" "so" "a")
    local found_lib=""
    
    for ext in "${lib_extensions[@]}"; do
        if [ -f "td/build/libtdjson.$ext" ]; then
            found_lib="td/build/libtdjson.$ext"
            break
        fi
    done
    
    if [ -n "$found_lib" ]; then
        log_success "TdLib library found: $found_lib"
        
        # Get file size
        local file_size=$(ls -lh "$found_lib" | awk '{print $5}')
        log_info "Library size: $file_size"
        
        # Check if it's a valid library file
        if command -v file >/dev/null 2>&1; then
            local file_type=$(file "$found_lib")
            log_info "File type: $file_type"
        fi
        
        return 0
    else
        log_error "TdLib library not found in td/build/"
        return 1
    fi
}

# Print installation summary
print_summary() {
    echo
    echo "=================================================="
    echo "           TdLib Installation Summary"
    echo "=================================================="
    echo
    log_success "Platform: $PLATFORM ($DISTRO) - $ARCH"
    
    if [ -f "td/build/libtdjson.dylib" ]; then
        log_success "Library: td/build/libtdjson.dylib (Dynamic)"
        echo "Python usage: tdjson_path = os.path.abspath('td/build/libtdjson.dylib')"
    elif [ -f "td/build/libtdjson.so" ]; then
        log_success "Library: td/build/libtdjson.so (Dynamic)"
        echo "Python usage: tdjson_path = os.path.abspath('td/build/libtdjson.so')"
    elif [ -f "td/build/libtdjson.a" ]; then
        log_success "Library: td/build/libtdjson.a (Static)"
        echo "Python usage: tdjson_path = os.path.abspath('td/build/libtdjson.a')"
    fi
    
    echo
    echo "Next steps:"
    echo "1. Import the library in your Python code using ctypes"
    echo "2. Check TdLib documentation: https://core.telegram.org/tdlib"
    echo "3. See examples: https://github.com/tdlib/td/tree/master/example"
    echo
    echo "=================================================="
}

# Show help
show_help() {
    echo "TdLib Installation Script"
    echo
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -f, --force             Force reinstallation (clean everything)"
    echo "  -s, --skip-deps         Skip dependency installation"
    echo "  -v, --verify-only       Only verify existing installation"
    echo
    echo "Examples:"
    echo "  $0                      # Normal installation"
    echo "  $0 --force              # Force clean reinstallation"
    echo "  $0 --skip-deps          # Skip dependency installation"
    echo "  $0 --verify-only        # Only verify installation"
    echo
}

# Main installation function
main() {
    local force_install=false
    local skip_deps=false
    local verify_only=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -f|--force)
                force_install=true
                shift
                ;;
            -s|--skip-deps)
                skip_deps=true
                shift
                ;;
            -v|--verify-only)
                verify_only=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    echo "🚀 TdLib Installation Script Started"
    echo "===================================="
    
    # Detect platform
    detect_platform
    
    # Verify only mode
    if [ "$verify_only" = true ]; then
        if verify_installation; then
            print_summary
            exit 0
        else
            exit 1
        fi
    fi
    
    # Force clean installation
    if [ "$force_install" = true ]; then
        log_warning "Force installation requested - cleaning everything..."
        rm -rf td
    fi
    
    # Install dependencies
    if [ "$skip_deps" = false ]; then
        install_dependencies
    else
        log_info "Skipping dependency installation as requested"
    fi
    
    # Download TdLib
    download_tdlib
    
    # Apply platform-specific fixes
    fix_macos_atomics
    
    # Build TdLib
    build_tdlib
    
    # Verify installation
    if ! verify_installation; then
        error_exit "Installation verification failed"
    fi
    
    # Print summary
    print_summary
    
    log_success "🎉 TdLib installation completed successfully!"
}

# Trap to handle script interruption
trap 'log_error "Script interrupted by user"; exit 130' INT TERM

# Run main function with all arguments
main "$@" 