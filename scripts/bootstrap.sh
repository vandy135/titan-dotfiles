#!/usr/bin/env bash
# Bootstrap a fresh macOS machine.
# Usage: curl -fsSL https://raw.githubusercontent.com/<you>/titan-dotfiles/prod/scripts/bootstrap.sh | bash
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

# Optional: force a specific SSH key for the chezmoi clone.
# Useful when the agent has multiple keys or when ssh config doesn't pin one.
# Only set this if you actually need it — by default we trust your ssh config + agent.
if [[ -n "${SSH_KEY:-}" ]]; then
    echo "==> Using SSH key: $SSH_KEY"
    export GIT_SSH_COMMAND="ssh -i $SSH_KEY -o IdentitiesOnly=yes"
fi

# Verify SSH auth to github.com using the user's normal config (no -i / IdentitiesOnly).
# This avoids a footgun: with -i + BatchMode, ssh needs a .pub file next to the private
# key to query the agent — if missing, it tries to decrypt the private key and fails.
if [[ "$REPO_URL" == git@github.com:* ]]; then
    echo "==> Verifying SSH access to github.com..."
    if ! ssh -T -o BatchMode=yes -o StrictHostKeyChecking=accept-new git@github.com 2>&1 | grep -q "successfully authenticated"; then
        cat <<EOF >&2

ERROR: SSH auth to github.com failed.

Make sure your SSH key is added to GitHub and loaded in the agent:
  ssh-add --apple-use-keychain ~/.ssh/github
  ssh -T git@github.com

If \`ssh -T git@github.com\` works interactively but this preflight fails,
your key may need its agent entry refreshed, or you can bypass this script:
  chezmoi init --apply $REPO_URL

For non-default key names, you can also pin one explicitly:
  SSH_KEY=~/.ssh/github $0

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
