# -----------------------------------------------------------------------------
#  Prompt
# -----------------------------------------------------------------------------
autoload -U colors && colors

# With this zsh option endabled, PROMPT and RPROMPT should be enclosed in
# single quotes so their inner expressions are re-evaluated each time they're
# used. Fixes issue where zsh subshells (e.g., vim's :sh command) had repeated
# strings in RPROMPT.
setopt promptsubst

# Conditionally color the exit code of the previous command to be RED if the
# exit code is non-zero. Otherwise, if the exit color is zero, don't alter its
# color.
local exit_code="%(?,%?,%{$fg[red]%}%?%{$reset_color%})"

# This prompt format was inspired by the "ys" theme in the "oh-my-zsh" package.
# Here's the format (the '|' character indicates the left side of the terminal,
# it is not actually printed in the prompt).
#
#     |<empty-line>
#     |# <current-working-directory> [<iso8601-timestamp>] [<previous-command-exit-code>] [VIM]
#     |$ <cursor>
#
# If the current shell was started within vim by the :sh command, the
# VIMRUNTIME environment variable will be defined (its value is meaningless,
# what matters is that it's not null). The Bash parameter substitution used
# below checks if VIMRUNTIME is defined -- iff it's defined then "[VIM]" is
# appended to PROMPT.
# TODO: move this vim-specific feature to the vim directory
PROMPT="
%{$fg[gray]%}${PROMPT_PREFIX:-#}%{$reset_color%} \
%{$fg[white]%}%~%{$reset_color%}\
 \
%{$fg[gray]%}[%D{%Y-%m-%d %H:%M:%S}] [$exit_code] \
${VIMRUNTIME+[VIM]}
%{$fg[yellow]%}$ %{$reset_color%}"

# NOTE: The Prompt I'm using above does away with the need for a right-aligned,
# current-working-directory. But I'm leaving this here for future reference.
# I thought "%~" would print the current directory with "~" replacing "$HOME"
# but it turns out that "%~" also replaces substrings of the current path with
# any matching environment variables. See
# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/#current-directory
# for a better explanation of the problem and the recommended fix used below.
#RPROMPT='%F{cyan}${PWD/#$HOME/~}%f'


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

# ZSH feature to temporarily clear the current command, providing you with an
# empty prompt to run another command, and then replacing the prior contents
# into the next prompt. More details here:
# https://nathangrigg.com/2014/04/zsh-push-line-or-edit
bindkey '^b' push-line


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

# zsh parameters (name=value pairs) are described in detail in `man zshparam`.
HISTFILE=~/.zsh_history

# Maximum number of commands to save in local (per shell, in-memory) history
HISTSIZE=15000

# Maximum numer of commands to save in $HISTFILE
SAVEHIST=15000

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

# Save  each  command's beginning timestamp (in seconds since the epoch) and
# the duration (in seconds) to the history file. A little extra information
# can't hurt...
setopt EXTENDED_HISTORY

# Normally (without this option) zsh appends a shell's complete local command
# history to $HISTFILE only on shell exit. Thus $HISTFILE doesn't contain
# commands from currently running shells. Since a new shell's local history is
# initialized with the contents of $HISTFILE, the local history won't contain
# commands from currently running shells.
#
# The INC_APPEND_HISTORY option changes this -- it tells zsh to append commands
# to $HISTFILE as soon as they're entered. Therefore, with this option enabled,
# when a new shell's local history is initialized with $HISTFILE, it will
# contain commands entered from currently running shells. The SHARE_HISTORY
# option takes this even further by (basically) causing a shell's local history
# to continually import new commands from $HISTFILE instead of just at startup.
# I'm not crazy about sharing history between currently running shells, so the
# INC_APPEND_HISTORY option is as far as I take it...
setopt INC_APPEND_HISTORY


# -----------------------------------------------------------------------------
#  Completion
# -----------------------------------------------------------------------------

# case insensitive, partial-word, and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
