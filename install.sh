#!/usr/bin/env bash
set -euo pipefail

# Rig v5.0 Installer — Harness-Core Workflow Framework
# Usage: curl -fsSL https://raw.githubusercontent.com/xuanhoatrieu/rig/main/install.sh | bash

VERSION="5.0.0"
REPO="xuanhoatrieu/rig"
GEMINI_DIR="$HOME/.gemini"
ANTIGRAVITY_DIR="$GEMINI_DIR/antigravity"
BIN_DIR="$HOME/.local/bin"

echo "🚀 Installing Rig v${VERSION}..."

# ─── Detect OS and Architecture ───
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$OS" in
    linux)  OS_TARGET="linux" ;;
    darwin) OS_TARGET="darwin" ;;
    *)      echo "❌ Unsupported OS: $OS"; exit 1 ;;
esac

case "$ARCH" in
    x86_64|amd64)   ARCH_TARGET="x86_64" ;;
    aarch64|arm64)   ARCH_TARGET="aarch64" ;;
    *)               echo "❌ Unsupported architecture: $ARCH"; exit 1 ;;
esac

BINARY_NAME="rig-${OS_TARGET}-${ARCH_TARGET}"
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/v${VERSION}/${BINARY_NAME}"

# ─── Create directories ───
mkdir -p "$ANTIGRAVITY_DIR/core/templates/high-risk-story"
mkdir -p "$ANTIGRAVITY_DIR/workflows"
mkdir -p "$BIN_DIR"

# ─── Download rig binary ───
echo "📦 Downloading rig binary for ${OS_TARGET}-${ARCH_TARGET}..."
if command -v curl &>/dev/null; then
    curl -fsSL "$DOWNLOAD_URL" -o "$BIN_DIR/rig" 2>/dev/null || {
        echo "⚠️  Binary download failed. You can build from source:"
        echo "   cd cli && cargo build --release"
        echo "   cp target/release/rig $BIN_DIR/"
    }
elif command -v wget &>/dev/null; then
    wget -q "$DOWNLOAD_URL" -O "$BIN_DIR/rig" 2>/dev/null || {
        echo "⚠️  Binary download failed. Build from source instead."
    }
fi

if [ -f "$BIN_DIR/rig" ]; then
    chmod +x "$BIN_DIR/rig"
    echo "✅ rig binary installed to $BIN_DIR/rig"
fi

# ─── Install core docs ───
echo "📄 Installing core docs..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# If running from cloned repo, copy local files
if [ -d "$SCRIPT_DIR/core" ]; then
    cp -r "$SCRIPT_DIR/core/"* "$ANTIGRAVITY_DIR/core/"
    cp -r "$SCRIPT_DIR/workflows/"* "$ANTIGRAVITY_DIR/workflows/"
    echo "✅ Core docs and workflows installed from local repo"
else
    # Download from GitHub
    echo "📥 Downloading from GitHub..."
    TMPDIR=$(mktemp -d)
    curl -fsSL "https://github.com/${REPO}/archive/refs/heads/main.tar.gz" | tar xz -C "$TMPDIR"
    cp -r "$TMPDIR/rig-main/core/"* "$ANTIGRAVITY_DIR/core/"
    cp -r "$TMPDIR/rig-main/workflows/"* "$ANTIGRAVITY_DIR/workflows/"
    rm -rf "$TMPDIR"
    echo "✅ Core docs and workflows downloaded"
fi

# ─── Install GEMINI.md ───
echo "📝 Installing GEMINI.md..."
if [ -f "$SCRIPT_DIR/gemini.md" ]; then
    cp "$SCRIPT_DIR/gemini.md" "$GEMINI_DIR/GEMINI.md"
else
    curl -fsSL "https://raw.githubusercontent.com/${REPO}/main/gemini.md" -o "$GEMINI_DIR/GEMINI.md"
fi

# ─── Save version ───
echo "$VERSION" > "$GEMINI_DIR/rig_version"

# ─── Add to PATH if needed ───
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    SHELL_RC=""
    if [ -f "$HOME/.zshrc" ]; then
        SHELL_RC="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        SHELL_RC="$HOME/.bashrc"
    fi

    if [ -n "$SHELL_RC" ]; then
        if ! grep -q "$BIN_DIR" "$SHELL_RC" 2>/dev/null; then
            echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$SHELL_RC"
            echo "📌 Added $BIN_DIR to PATH in $SHELL_RC"
        fi
    fi
fi

# ─── Project init (if in a project directory) ───
if [ -f "package.json" ] || [ -f "Cargo.toml" ] || [ -f "requirements.txt" ] || [ -f "go.mod" ]; then
    echo ""
    echo "📂 Detected project in current directory."
    if [ ! -f "harness.db" ] && [ -f "$BIN_DIR/rig" ]; then
        echo "   Running: rig init"
        "$BIN_DIR/rig" init 2>/dev/null || true
    fi
fi

# ─── Summary ───
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Rig v${VERSION} installed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📁 Installed to:"
echo "   Binary:    $BIN_DIR/rig"
echo "   Core:      $ANTIGRAVITY_DIR/core/"
echo "   Workflows: $ANTIGRAVITY_DIR/workflows/"
echo "   GEMINI.md: $GEMINI_DIR/GEMINI.md"
echo ""
echo "🎮 Quick start:"
echo "   In your project, type /init in AI chat"
echo "   Or run: rig init"
echo ""
echo "📖 Help: /help or rig --help"
