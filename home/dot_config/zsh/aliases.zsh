alias ls='eza --group-directories-first'
alias l='eza -lah --group-directories-first --git'
alias ll='eza -lh --group-directories-first --git'
alias la='eza -lah --group-directories-first --git'
alias lt='eza --tree --level=2 --group-directories-first'

alias cat='bat --paging=never'
alias less='bat'

alias cd='z'
alias cdi='zi'

alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate'

alias v='nvim'
alias vim='nvim'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias reload='exec zsh'
alias path='echo -e ${PATH//:/\\n}'
