#!/usr/bin/env python3
"""
TdLib Basic Usage Example

This example demonstrates how to load and use TdLib after installation
using the TdLib Universal Installer.

Requirements:
- TdLib installed using the installer script
- Python 3.6+

Usage:
    python3 basic_usage.py
"""

import os
import sys
import json
import ctypes
from ctypes import c_char_p, c_double, c_int, c_void_p

def find_tdlib_path():
    """Find the TdLib library path based on platform."""
    possible_paths = [
        'td/build/libtdjson.dylib',  # macOS
        'td/build/libtdjson.so',     # Linux
        'td/build/libtdjson.a',      # Static library
        '../td/build/libtdjson.dylib',  # If running from examples/
        '../td/build/libtdjson.so',     # If running from examples/
        '../td/build/libtdjson.a',      # If running from examples/
    ]
    
    for path in possible_paths:
        full_path = os.path.abspath(path)
        if os.path.exists(full_path):
            return full_path
    
    return None

def load_tdlib():
    """Load TdLib library and configure function signatures."""
    tdlib_path = find_tdlib_path()
    
    if not tdlib_path:
        print("❌ TdLib library not found!")
        print("Please run the installer script first:")
        print("  ./install.sh")
        sys.exit(1)
    
    print(f"📚 Loading TdLib from: {tdlib_path}")
    
    try:
        # Load the library
        tdjson = ctypes.CDLL(tdlib_path)
        
        # Configure function signatures
        tdjson.td_json_client_create.restype = c_void_p
        tdjson.td_json_client_send.argtypes = [c_void_p, c_char_p]
        tdjson.td_json_client_receive.argtypes = [c_void_p, c_double]
        tdjson.td_json_client_receive.restype = c_char_p
        tdjson.td_json_client_execute.argtypes = [c_void_p, c_char_p]
        tdjson.td_json_client_execute.restype = c_char_p
        tdjson.td_json_client_destroy.argtypes = [c_void_p]
        
        return tdjson
        
    except Exception as e:
        print(f"❌ Failed to load TdLib: {e}")
        sys.exit(1)

def test_tdlib_basic_functionality(tdjson):
    """Test basic TdLib functionality."""
    print("🧪 Testing TdLib basic functionality...")
    
    # Create a client
    client = tdjson.td_json_client_create()
    if not client:
        print("❌ Failed to create TdLib client")
        return False
    
    print(f"✅ TdLib client created successfully: {client}")
    
    try:
        # Test getting TdLib version
        query = json.dumps({
            "@type": "getOption",
            "name": "version"
        })
        
        result = tdjson.td_json_client_execute(client, query.encode('utf-8'))
        
        if result:
            result_str = result.decode('utf-8')
            result_json = json.loads(result_str)
            version = result_json.get('value', 'Unknown')
            print(f"✅ TdLib version: {version}")
        else:
            print("⚠️  Could not retrieve TdLib version")
        
        # Test getting commit hash
        query = json.dumps({
            "@type": "getOption",
            "name": "commit_hash"
        })
        
        result = tdjson.td_json_client_execute(client, query.encode('utf-8'))
        
        if result:
            result_str = result.decode('utf-8')
            result_json = json.loads(result_str)
            commit = result_json.get('value', 'Unknown')
            print(f"✅ TdLib commit: {commit[:12]}...")
        
        return True
        
    except Exception as e:
        print(f"❌ Error during testing: {e}")
        return False
        
    finally:
        # Clean up
        tdjson.td_json_client_destroy(client)
        print("✅ TdLib client destroyed successfully")

def main():
    """Main function."""
    print("🚀 TdLib Basic Usage Example")
    print("=" * 40)
    
    # Load TdLib
    tdjson = load_tdlib()
    print("✅ TdLib library loaded successfully!")
    
    # Test basic functionality
    if test_tdlib_basic_functionality(tdjson):
        print("\n🎉 TdLib is working perfectly!")
        print("\nNext steps:")
        print("1. Check the TdLib documentation: https://core.telegram.org/tdlib")
        print("2. Explore more examples: https://github.com/tdlib/td/tree/master/example")
        print("3. Start building your Telegram application!")
    else:
        print("\n❌ TdLib testing failed")
        sys.exit(1)

if __name__ == "__main__":
    main() 