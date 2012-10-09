# Tell ls to colorize its output. Due to the fact that ls' colorize-output
# option is OS-specific, I decide which colorize-output option to use via
# Bash's OSTYPE (which also works in ZSH).
if [[ "$OSTYPE" == "darwin"* ]]; then
  # OSX (no coreutils)
  alias ls='ls -G'

elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  # Standard Linux (Ubuntu, Fedora, etc) with coreutils' ls
  alias ls='ls --color=auto'
fi

alias ll='ls -alh'

alias u='cd .. && ls'
alias uu='cd ../.. && ls'
alias uuu='cd ../../.. && ls'
alias uuuu='cd ../../../.. && ls'

alias grep='grep --color=auto'
