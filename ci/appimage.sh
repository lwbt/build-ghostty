#!/bin/bash
set -x
rm -rf AppDir ./*.AppImage ./*.zsync
set -e

# Set up base AppDir structure
APP_DIR="AppDir"
mkdir -p "${APP_DIR}/usr"

install -Dsm755 -t ${APP_DIR}/usr/bin ghostty/zig-out/bin/ghostty
## TODO: Evenually copy the entire ghostty/zig-out/share structure as is to AppDir/usr/share.
#install -Dm644 ghostty/zig-out/share/icons/hicolor/128x128/apps/com.mitchellh.ghostty.png AppDir/usr/share/icons/hicolor/128x128/apps/com.mitchellh.ghostty.png
#install -Dm644 ghostty/zig-out/share/applications/com.mitchellh.ghostty.desktop AppDir/usr/share/applications/com.mitchellh.ghostty.desktop
install -Dm644 assets/ghostty.appdata.xml AppDir/usr/share/metainfo/com.mitchellh.ghostty.appdata.xml
#install -Dm644 ghostty/zig-out/share/nautilus-python/extensions/com.mitchellh.ghostty.py AppDir/usr/share/nautilus-python/extensions/com.mitchellh.ghostty.py

# Install all share files while preserving directory structure
find ghostty/zig-out/share -type f | while read -r file; do
  # Convert path to target path
  target="${APP_DIR}/usr/${file#ghostty/zig-out/}"
  # Create target directory
  mkdir -p "$(dirname "$target")"
  # Install file with correct permissions (644 for regular files)
  install -Dm644 "$file" "$target"
done

[ -x /tmp/linuxdeploy ] || ( curl -L 'https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage' -o /tmp/linuxdeploy && chmod +x /tmp/linuxdeploy )

# NOTE: This was is from WezTerm, result looks like: 20250109-124341-6ef757a8. Please choose something appropriate for Ghostty upstream builds or personal builds.
TAG_NAME=${TAG_NAME:-$(git -c "core.abbrev=8" show -s "--format=%cd-%h" "--date=format:%Y%m%d-%H%M%S")}
# Dummy for integrataing into different project.
TAG_NAME="$(date +%Y%m%d-%H%M%S)-00000000"
# NOTE END
distro=$(lsb_release -is 2>/dev/null || sh -c "source /etc/os-release && echo \$NAME")
distver=$(lsb_release -rs 2>/dev/null || sh -c "source /etc/os-release && echo \$VERSION_ID")

# Embed appropriate update info
# https://github.com/AppImage/AppImageSpec/blob/master/draft.md#github-releases
if [[ "$BUILD_REASON" == "Schedule" ]] ; then
  # TODO: Looks like the relates to the GitHub repository.
  UPDATE="gh-releases-zsync|ghostty-org|ghostty|nightly|Ghostty-*.AppImage.zsync"
  OUTPUT=Ghostty-nightly-$distro$distver.AppImage
else
  # TODO: Looks like the relates to the GitHub repository.
  UPDATE="gh-releases-zsync|ghostty-org|ghostty|latest|Ghostty-*.AppImage.zsync"
  OUTPUT=Ghostty-$TAG_NAME-$distro$distver.AppImage
fi

# Munge the path so that it finds our appstreamcli wrapper
PATH="$PWD/ci:$PATH" \
LINUXDEPLOY_OUTPUT_VERSION="$TAG_NAME" \
LDAI_UPDATE_INFORMATION="$UPDATE" \
LDAI_OUTPUT="$OUTPUT" \
  /tmp/linuxdeploy \
  --exclude-library='libwayland-client.so.0' \
  --appdir AppDir \
  --output appimage \
  --desktop-file ghostty/zig-out/share/applications/com.mitchellh.ghostty.desktop
