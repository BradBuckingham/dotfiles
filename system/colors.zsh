if [[ "$OSTYPE" == "darwin"* ]]; then
  # OSX's default ls color scheme
  export LSCOLORS="exfxcxdxbxegedabagacad"

  # OSX's default ls color scheme converted to Linux-style LS_COLORS (see
  # http://geoff.greer.fm/lscolors/) for use in zsh's tab-completion list
  # (setup below). I made a small tweak to the background color of directories
  # so that it matches the Solarized background color: when using the
  # previously-linked tool, set Background to "Bold" for Directories.
  export LS_COLORS="di=34;:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"

elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  # Load Solarized-inspired ls color scheme via coreutils' dircolors command.
  # Eval'ing the result of dircolors sets LS_COLORS to the chosen color scheme.
  eval `dircolors $DOTFILES/system/colors/dircolors.ansi-dark`
fi

# Now that LS_COLORS is set, we can tell zsh to use those colors when
# displaying tab-completion list of files and folders
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
