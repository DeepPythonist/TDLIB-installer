# TdLib Usage Examples

This directory contains practical examples demonstrating how to use TdLib after installation with the TdLib Universal Installer.

## 📁 Available Examples

### `basic_usage.py`
A comprehensive example showing:
- How to load TdLib library using ctypes
- Basic client creation and destruction
- Testing TdLib functionality
- Error handling and cleanup

**Usage:**
```bash
# From the main directory
python3 examples/basic_usage.py

# Or from the examples directory
cd examples
python3 basic_usage.py
```

## 🔧 Prerequisites

Before running these examples, ensure you have:

1. **TdLib installed** using the installer script:
   ```bash
   ./install.sh
   ```

2. **Python 3.6+** installed on your system

3. **TdLib library** available in one of these locations:
   - `td/build/libtdjson.dylib` (macOS)
   - `td/build/libtdjson.so` (Linux)
   - `td/build/libtdjson.a` (Static library)

## 🚀 Getting Started

1. **Install TdLib** (if not already done):
   ```bash
   ./install.sh
   ```

2. **Run the basic example**:
   ```bash
   python3 examples/basic_usage.py
   ```

3. **Expected output**:
   ```
   🚀 TdLib Basic Usage Example
   ========================================
   📚 Loading TdLib from: /path/to/td/build/libtdjson.dylib
   ✅ TdLib library loaded successfully!
   🧪 Testing TdLib basic functionality...
   ✅ TdLib client created successfully: 140123456789
   ✅ TdLib version: 1.8.0
   ✅ TdLib commit: abcd1234...
   ✅ TdLib client destroyed successfully
   
   🎉 TdLib is working perfectly!
   ```

## 🐛 Troubleshooting

### Library Not Found
```
❌ TdLib library not found!
```
**Solution**: Run the installer script first:
```bash
./install.sh
```

### Import Errors
```
ModuleNotFoundError: No module named 'ctypes'
```
**Solution**: Ensure you're using Python 3.6+ (ctypes is included in standard library)

### Permission Errors
```
OSError: cannot load library
```
**Solution**: Check file permissions and ensure the library file exists:
```bash
ls -la td/build/libtdjson.*
```

## 📚 Next Steps

After running these examples successfully:

1. **Read TdLib Documentation**: https://core.telegram.org/tdlib
2. **Explore Official Examples**: https://github.com/tdlib/td/tree/master/example
3. **Check API Methods**: https://core.telegram.org/tdlib/docs/
4. **Build Your Application**: Start creating your Telegram bot or client

## 🤝 Contributing

Have a useful example to share? Please contribute:

1. Create your example file
2. Add documentation
3. Test on multiple platforms
4. Submit a pull request

---

*For more information, see the main [README.md](../README.md) file.* 