#!/bin/bash
# Patch macOS 26 SDK TBD files to add arm64-macos targets.
#
# Xcode 26.4 dropped arm64-macos from TBD targets, keeping only arm64e-macos.
# This breaks Zig, Rust, and any toolchain that targets arm64 instead of arm64e.
#
# This script adds arm64-macos back alongside arm64e-macos in all TBD files.
# Reversible: re-install Xcode or Command Line Tools to restore originals.
#
# Usage: sudo ./scripts/patch-macos26-sdk.sh

set -e

SDK="${1:-/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk}"

if [ ! -d "$SDK/usr/lib" ]; then
  echo "SDK not found at: $SDK"
  echo "Usage: sudo $0 [path-to-sdk]"
  exit 1
fi

# Check if already patched
if grep -q "arm64-macos" "$SDK/usr/lib/libSystem.B.tbd" 2>/dev/null; then
  echo "SDK already has arm64-macos targets. Nothing to do."
  exit 0
fi

echo "Patching macOS 26 SDK TBD files..."
echo "SDK: $SDK"

COUNT=0
while IFS= read -r f; do
  # Add arm64-macos wherever arm64e-macos appears
  sed -i '' 's/arm64e-macos/arm64-macos, arm64e-macos/g' "$f"
  # Add arm64-maccatalyst wherever arm64e-maccatalyst appears
  sed -i '' 's/arm64e-maccatalyst/arm64-maccatalyst, arm64e-maccatalyst/g' "$f"
  COUNT=$((COUNT + 1))
done < <(grep -rl "arm64e-macos" "$SDK/usr/lib/" --include="*.tbd" 2>/dev/null)

echo "Patched $COUNT TBD files."
echo ""

# Verify
echo "Verifying libSystem.B.tbd:"
head -4 "$SDK/usr/lib/libSystem.B.tbd"
