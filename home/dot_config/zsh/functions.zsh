mkcd() {
    mkdir -p "$1" && cd "$1"
}

extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.tar.xz)  tar xJf "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *)         echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

fcd() {
    local dir
    dir=$(fd --type d --hidden --exclude .git | fzf) && cd "$dir"
}

# Theme switcher — updates chezmoi config and re-applies templates.
# Reloads kitty in-place; nvim picks up the new theme on next launch.
theme() {
    local config="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.toml"
    local valid=("catppuccin-mocha" "gruvbox-dark" "everforest")

    if [[ -z "$1" ]]; then
        local current
        current=$(awk -F'"' '/^[[:space:]]*theme/ {print $2}' "$config")
        echo "Current: ${current:-unknown}"
        echo "Available: ${valid[*]}"
        return 0
    fi

    if ! [[ " ${valid[*]} " == *" $1 "* ]]; then
        echo "theme: unknown '$1'. Available: ${valid[*]}" >&2
        return 1
    fi

    local tmp
    tmp=$(mktemp)
    sed "s|^[[:space:]]*theme[[:space:]]*=.*|    theme = \"$1\"|" "$config" > "$tmp" \
        && mv "$tmp" "$config"

    chezmoi apply || return $?

    # Live-reload all running kitty instances.
    if command -v pgrep >/dev/null && pgrep -x kitty >/dev/null; then
        pkill -SIGUSR1 -x kitty
    fi

    echo "Theme set to $1. Restart nvim to pick up the change."
}
