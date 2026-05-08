#!/usr/bin/env bash
# Bootstrap a fresh macOS machine.
# Usage: curl -fsSL https://raw.githubusercontent.com/<you>/titan-dotfiles/main/scripts/bootstrap.sh | bash
# Or:    ./scripts/bootstrap.sh

set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/vandy135/titan-dotfiles.git}"

echo "==> Checking for Xcode Command Line Tools..."
if ! xcode-select -p >/dev/null 2>&1; then
    echo "    Installing Xcode Command Line Tools (a GUI prompt will appear)..."
    xcode-select --install
    echo "    Re-run this script once installation completes."
    exit 0
fi

echo "==> Checking for Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

echo "==> Installing chezmoi..."
brew install chezmoi

echo "==> Initializing dotfiles from $REPO_URL..."
chezmoi init --apply "$REPO_URL"

echo "==> Installing Brewfile packages..."
brew bundle --file="$HOME/.local/share/chezmoi/Brewfile" || \
    brew bundle --file="$(chezmoi source-path)/../Brewfile"

echo "==> Done. Open a new shell session."
