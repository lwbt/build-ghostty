# Ghostty Build Automation

This repository contains automation for building and releasing [Ghostty](https://github.com/ghostty-org/ghostty), a fast, feature-rich, and cross-platform terminal emulator that uses platform-native UI and GPU acceleration.


## Installation

### Method 1: Debian Package (Recommended for Debian/Ubuntu-based systems)
Download the latest `ghostty_<version>_amd64.deb` from the releases page and install it:
```bash
sudo dpkg -i ghostty_<version>_amd64.deb
sudo apt-get install -f  # Install any missing dependencies
```

After installation, you can:
- Launch Ghostty from your applications menu
- Run `ghostty` from the terminal

### Method 2: Portable Binary
If you prefer to run the portable version of Ghostty:

1. Download the latest `ghostty-linux-x86_64.tar.gz` from the releases page
2. Extract the archive:
```bash
tar xzf ghostty-linux-x86_64.tar.gz
```
3. Run the binary:
```bash
./ghostty
```

Note: You'll need the following dependencies installed:
```bash
sudo apt-get update
sudo apt-get install -y libgtk-4-dev libadwaita-1-dev
```

## Building Manually

If you want to build Ghostty locally:

1. Install system dependencies:
```bash
sudo apt-get update
sudo apt-get install -y libgtk-4-dev libadwaita-1-dev git
```

2. Install Zig:
```bash
wget https://ziglang.org/download/0.13.0/zig-linux-x86_64-0.13.0.tar.xz
tar xvf zig-linux-x86_64-0.13.0.tar.xz
```

3. Clone and build:
```bash
git clone https://github.com/ghostty-org/ghostty.git
cd ghostty
../zig-linux-x86_64-0.13.0/zig build -Doptimize=ReleaseFast
```

4. Run:
```bash
./zig-out/bin/ghostty
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.