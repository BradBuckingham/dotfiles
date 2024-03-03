# Prepending '/opt/homebrew/bin' to PATH for Homebrew on Apple Silicon Macs
# and '/usr/local/bin' for Homebrew on Intel Macs. For systems without
# homebrew installed (Linux, for example) this should be innocuous.
#
# Also, prepending '$DOTFILES/bin' so that anything in dotfiles' bin
# directory is automatically available.
export PATH="/opt/homebrew/bin:/usr/local/bin:$DOTFILES/bin:$PATH"
