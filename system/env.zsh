# default to Vim
export EDITOR="vim"

# less:
#   -R show colors. Originally I had this as -r (lowercase r) but this caused
#      display issues when long lines of text would wrap. For example when
#      invoking "git log --color --decorate --graph --all", the first line of
#      the file wasn't initially visible. I had to press "G" to scroll to the
#      top. Source of fix: http://www.greenwoodsoftware.com/less/faq.html#dashr
#
#   -i use case-insensitive search for all lowercase search patterns. This
#      option is ignored if the search pattern contains any uppercase letters.
export LESS="-Ri"
