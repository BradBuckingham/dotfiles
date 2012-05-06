# -----------------------------------------------------------------------------
#  Prompt
# -----------------------------------------------------------------------------
autoload -U colors && colors

PROMPT="%{$fg[yellow]%}$%{$reset_color%} "
RPROMPT="%{$fg_bold[cyan]%}%~%{$reset_color%}"


# -----------------------------------------------------------------------------
#  Window
# -----------------------------------------------------------------------------

# From http://dotfiles.org/~_why/.zshrc
# Sets the window title nicely no matter where you are
function title() {
  # escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
  screen)
    print -Pn "\ek$a:$3\e\\" # screen title (in ^A")
    ;;
  xterm*|rxvt)
    print -Pn "\e]2;$2\a" # plain xterm title ($3 for pwd)
    ;;
  esac
}


# -----------------------------------------------------------------------------
#  Key bindings
# -----------------------------------------------------------------------------

# Emacs-style key bindings. Vim-style key bindings are too
# complicated because I can't make zsh show the current
# Vim "mode" (normal, insert, etc)
bindkey -e

# Fix the delete key (fn-delete for us Mac people)
bindkey '^[[3~' delete-char


# -----------------------------------------------------------------------------
#  ZSH Options
# -----------------------------------------------------------------------------

####
# Take a look at `man zshoptions` for information on zsh options
# that are set via "setopt"
####

# Do not exit on end-of-file. Require exit or logout, instead.
setopt IGNORE_EOF

# Don't run background jobs at lower priority.
setopt NO_BG_NICE

# Report  the  status of background and suspended jobs before exiting
# a shell with job control; a second attempt to exit the shell will succeed.
setopt CHECK_JOBS

# Do not beep on an ambiguous completion.
setopt NO_LIST_BEEP

# Make 'cd' push the old directory onto the directory stack (visible by
# issuing 'cd -<tab>')
setopt AUTO_PUSHD

# -----------------------------------------------------------------------------
#  History
# -----------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Don't overwrite history, append
setopt APPEND_HISTORY

# Do not save commands to the history if they duplicate the
# previous command. This helps when moving through history
# with the up-arrow -- it'll skip over duplicate invocation
# of the same command
setopt HIST_IGNORE_DUPS

# Remove blanks from command before saving to history
setopt HIST_REDUCE_BLANKS

# Let the user edit the command line after history expansion (e.g., !cd) but
# before executing the command. Without this option set, the command is
# immediately executed.
setopt HIST_VERIFY


# -----------------------------------------------------------------------------
#  Completion
# -----------------------------------------------------------------------------

# case insensitive, partial-word, and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
