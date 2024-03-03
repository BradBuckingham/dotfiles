# Possible Homebrew install locations:
#   /opt/homebrew     (on Apple Silicon Macs)
#   /usr/local        (on Intel Macs)
for homebrew_location in /opt/homebrew /usr/local; do
  if [[ -f ${homebrew_location}/bin/brew ]]; then
    eval "$(${homebrew_location}/bin/brew shellenv)"
    break
  fi
done
