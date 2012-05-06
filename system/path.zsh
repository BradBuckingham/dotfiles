# Prepending '/usr/local/bin' to PATH (for homebrew). For systems without
# homebrew installed (Linux, for example) this change should be innocuous.
#
# Also, prepending '$DOTFILES/bin' so that anything in dotfiles' bin
# directory is automatically available.
export PATH="/usr/local/bin:$DOTFILES/bin:$PATH"
