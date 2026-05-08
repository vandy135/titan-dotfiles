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
curl -fsSL https://raw.githubusercontent.com/vandy135/titan-dotfiles/main/scripts/bootstrap.sh | bash
```

Or manually:

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi
chezmoi init --apply https://github.com/vandy135/titan-dotfiles.git
brew bundle --file="$HOME/.local/share/chezmoi/Brewfile"
```

`chezmoi init` will prompt for name, email, and GitHub username (templated into `~/.gitconfig`).

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
    └── dot_config/
        ├── starship.toml
        ├── aerospace/aerospace.toml
        ├── zsh/{aliases,exports,functions,plugins}.zsh
        ├── kitty/kitty.conf
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
