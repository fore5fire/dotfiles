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
setopt hist_ignore_dups
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

function precmd () {
    window_title="\033]0;% ${PWD##*/}\007"
    echo -ne "$window_title"
} 

source "$HOME/.profile"

# Modal cursor color for vi's insert/normal modes.
# http://stackoverflow.com/questions/30985436/
# https://bbs.archlinux.org/viewtopic.php?id=95078
# http://unix.stackexchange.com/questions/115009/
zle-line-init () {
  zle -K viins
  #echo -ne "\033]12;Grey\007"
  #echo -n 'grayline1'
  echo -ne "\033]12;Gray\007"
  echo -ne "\033[4 q"
  #print 'did init' >/dev/pts/16
}
zle -N zle-line-init
zle-keymap-select () {
  if [[ $KEYMAP == vicmd ]]; then
    if [[ -z $TMUX ]]; then
      printf "\033]12;Green\007"
      printf "\033[2 q"
    else
      printf "\033Ptmux;\033\033]12;red\007\033\\"
      printf "\033Ptmux;\033\033[2 q\033\\"
    fi
  else
    if [[ -z $TMUX ]]; then
      printf "\033]12;Grey\007"
      printf "\033[4 q"
    else
      printf "\033Ptmux;\033\033]12;grey\007\033\\"
      printf "\033Ptmux;\033\033[4 q\033\\"
    fi
  fi
  #print 'did select' >/dev/pts/16
}
zle -N zle-keymap-select
