# Ghostty Build Automation

This repository contains automation for building and releasing [Ghostty](https://github.com/ghostty-org/ghostty), a modern terminal emulator, on Debian/Ubuntu systems.

## Usage
You can download the last build from releases page. Or you can build Ghostty manually as described below.


### Manual Build
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

### Automated Builds

To trigger an automated build and release:

1. Create and push a new tag:
```bash
git tag v1.0
git push origin v1.0
```

This will automatically:
- Build Ghostty with optimal settings
- Create a new GitHub release
- Upload the built binary

## License

This automation is provided under the same license as Ghostty. Please refer to the [Ghostty repository](https://github.com/ghostty-org/ghostty) for license details.