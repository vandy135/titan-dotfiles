#!/usr/bin/env bash
# Bootstrap a fresh macOS machine.
# Usage: curl -fsSL https://raw.githubusercontent.com/<you>/titan-dotfiles/main/scripts/bootstrap.sh | bash
# Or:    ./scripts/bootstrap.sh
#
# Defaults to SSH (GitHub no longer allows password auth over HTTPS).
# To use HTTPS instead (e.g. when bootstrapping before SSH keys are installed):
#   REPO_URL=https://github.com/vandy135/titan-dotfiles.git ./bootstrap.sh

set -euo pipefail

REPO_URL="${REPO_URL:-git@github.com:vandy135/titan-dotfiles.git}"

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

# If using SSH, verify the key is loaded and GitHub accepts it before chezmoi tries.
if [[ "$REPO_URL" == git@github.com:* ]]; then
    echo "==> Verifying SSH access to github.com..."
    if ! ssh -T -o BatchMode=yes -o StrictHostKeyChecking=accept-new git@github.com 2>&1 | grep -q "successfully authenticated"; then
        cat <<EOF >&2

ERROR: SSH auth to github.com failed.

Make sure your SSH key is added to GitHub and to the agent:
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
  ssh -T git@github.com

Or fall back to HTTPS for the clone:
  REPO_URL=https://github.com/vandy135/titan-dotfiles.git $0
EOF
        exit 1
    fi
fi

echo "==> Initializing dotfiles from $REPO_URL..."
chezmoi init --apply "$REPO_URL"

echo "==> Installing Brewfile packages..."
brew bundle --file="$HOME/.local/share/chezmoi/Brewfile" || \
    brew bundle --file="$(chezmoi source-path)/../Brewfile"

echo "==> Done. Open a new shell session."
