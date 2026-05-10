# titan-dotfiles

macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Stack

- **Shell**: zsh + [starship](https://starship.rs/) + [zinit](https://github.com/zdharma-continuum/zinit)
- **Terminal**: [Kitty](https://sw.kovidgoyal.net/kitty/)
- **Window manager**: [Aerospace](https://github.com/nikitabobko/AeroSpace) (i3-like, no SIP disable)
- **Launcher**: [Raycast](https://www.raycast.com/)
- **Editor**: Neovim with [lazy.nvim](https://github.com/folke/lazy.nvim)
- **CLI**: eza, zoxide, fzf, ripgrep, fd, bat, delta, gh, jq, mise, direnv

## Bootstrap a new Mac

```sh
curl -fsSL https://raw.githubusercontent.com/vandy135/titan-dotfiles/prod/scripts/bootstrap.sh | bash
```

Or manually:

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi
chezmoi init --apply https://github.com/vandy135/titan-dotfiles.git
brew bundle --file="$HOME/.local/share/chezmoi/Brewfile"
```

`chezmoi init` will prompt for name, email, GitHub username, and a theme.

## Theme switching

The `theme` chezmoi data var drives:

- **kitty** — `dot_config/kitty/kitty.conf.tmpl` includes `themes/<theme>.conf`
- **nvim** — `lua/config/colorscheme.lua.tmpl` selects the colorscheme
- **starship** — `starship.toml.tmpl` defines a per-theme `[palettes.theme]` block referenced by every style
- **bat** — `BAT_THEME` in `zsh/exports.zsh.tmpl` (gruvbox uses bat's built-in; others fall through to `ansi` and inherit the kitty palette)
- **macOS appearance** — `run_onchange_appearance.sh.tmpl` sets dark mode
- **wallpaper** — same script sets `~/.config/wallpapers/<theme>.png` as the desktop image. Drop a custom image at `home/dot_config/wallpapers/<theme>.png` to ship one with the repo; otherwise the script generates a solid-color PNG matching the terminal background as a fallback.

Switch with the shell function:

```sh
theme                    # show current + available
theme catppuccin-mocha   # rewrites ~/.config/chezmoi/chezmoi.toml,
theme gruvbox-dark       # runs `chezmoi apply`,
theme everforest         # SIGUSR1's running kitty instances to reload
```

`chezmoi apply` re-runs `run_onchange_appearance.sh` automatically whenever the
rendered theme changes, so kitty, the desktop, and macOS appearance all flip
together. Nvim still needs a restart to pick up the new colorscheme.

Adding a new theme touches:

- `dot_config/kitty/themes/<name>.conf` — kitty palette
- `dot_config/nvim/lua/config/colorscheme.lua.tmpl` — nvim branch
- `dot_config/starship.toml.tmpl` — `[palettes.theme]` block
- `dot_config/zsh/exports.zsh.tmpl` — `BAT_THEME` if a built-in match exists
- `run_onchange_appearance.sh.tmpl` — `BG_HEX` branch (and dark/light if mixing)
- `dot_config/zsh/functions.zsh` — `valid` array in `theme()`
- `.chezmoi.toml.tmpl` — `$themes` list

## Layout

```
.
├── .chezmoiroot              points at home/
├── Brewfile                  brew/cask/mas packages
├── scripts/bootstrap.sh
└── home/                     chezmoi source dir
    ├── .chezmoi.toml.tmpl    init prompts
    ├── .chezmoiignore
    ├── dot_zshenv            early env (PATH, XDG)
    ├── dot_zshrc             loader; sources dot_config/zsh/
    ├── dot_gitconfig.tmpl
    ├── dot_gitignore_global
    ├── run_onceafter_macos-defaults.sh
    ├── run_onchange_appearance.sh.tmpl  re-runs on theme change
    └── dot_config/
        ├── starship.toml.tmpl
        ├── aerospace/aerospace.toml
        ├── zsh/{aliases,exports.tmpl,functions,plugins}.zsh
        ├── kitty/kitty.conf.tmpl
        └── nvim/{init.lua,lua/...}
```

## Common chezmoi commands

```sh
chezmoi edit ~/.zshrc          # edit the source for ~/.zshrc
chezmoi diff                   # preview changes before applying
chezmoi apply                  # apply changes to $HOME
chezmoi cd                     # cd into source directory
chezmoi update                 # pull latest + apply
chezmoi re-add                 # re-import a file you've changed in $HOME
```
