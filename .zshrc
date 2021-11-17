# The following lines were added by compinstall

zstyle ':completion:*' list-suffixes true
zstyle :compinstall filename '/home/l/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=10000
# End of lines configured by zsh-newuser-install

# Setup prompt
PROMPT='%F{green}%T%f%# '
RPROMPT='%F{green}%~%f'

# Setup keybinds
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

source "$HOME/.profile"
