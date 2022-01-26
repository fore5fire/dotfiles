# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/l/.zshrc'
zstyle ':completion:*' list-suffixes true
 
autoload -Uz compinit
compinit
# End of lines added by compinstall

# Setup prompt
PROMPT_NORMAL='%F{blue}NORMAL%f%# '
PROMPT_INSERT='%F{green}INSERT%f%# '
PROMPT_VISUAL='%F{red}VISUAL%f%# '
PROMPT="$PROMPT_NORMAL"
RPROMPT='%F{green}%~%f'

# Setup keybinds
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word 
bindkey "^H" backward-delete-char      # Control-h also deletes the previous char
bindkey "^U" backward-kill-line 
bindkey -a '^[[3~' vi-delete-char
bindkey '^[[3~' delete-char

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
vi-mode-indicators() {
  if [[ $KEYMAP == vicmd ]] && (( REGION_ACTIVE )); then
    echo -ne "\033P\033]12;#aa1111\007\033\\" 
    printf "\033[2 q"
  elif [[ $KEYMAP == vicmd ]]; then
    if [[ $TERM == "alacritty" ]]; then
        echo -ne "\033P\033]12;#ffffff\007\033\\" 
        printf "\033[2 q"
    elif [[ -z $TMUX ]]; then
      printf "\033]12;Green\007"
      printf "\033[2 q"
    else
      printf "\033Ptmux;\033\033]12;red\007\033\\"
      printf "\033Ptmux;\033\033[2 q\033\\"
    fi
  else
    if [[ $TERM == "alacritty" ]]; then
        echo -ne "\033P\033]12;#ffffff\007\033\\" 
        printf "\033[6 q"
    elif [[ -z $TMUX ]]; then
      printf "\033]12;Grey\007"
      printf "\033[6 q"
    else
      printf "\033Ptmux;\033\033]12;grey\007\033\\"
      printf "\033Ptmux;\033\033[6 q\033\\"
    fi
  fi
  local new="$PS1"
  if [[ $KEYMAP == vicmd ]] && (( REGION_ACTIVE )); then
    new="$PROMPT_VISUAL"
  elif [[ $KEYMAP == vicmd ]]; then
      new="$PROMPT_NORMAL"
  else
    new="$PROMPT_INSERT"
  fi
  if [[ $new != $PS1 ]]; then
   PS1="$new"
   zle .reset-prompt
  fi
}
zle-line-init () {
  #zle -K viins
  #echo -ne "\033]12;Gray\007"
  #echo -ne "\033[4 q"

  zle -K vicmd
  vi-mode-indicators
}
zle -N zle-line-init
zle-line-pre-redraw() {
    vi-mode-indicators
}
zle -N zle-line-pre-redraw


