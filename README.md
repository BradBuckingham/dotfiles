# dotfiles

## Installation dependencies

### OSX

* XCode (for build tools)
* [Homebrew] (http://mxcl.github.com/homebrew/)
  * git
* [rvm] (https://rvm.io/rvm/install/)
  * Ruby (MRI) 1.9.3

### Linux (Debian)

* apt-get install git
* [rvm] (https://rvm.io/rvm/install/)
  * Ruby (MRI) 1.9.3

## Install

```
git clone --recursive git://github.com/BradBuckingham/dotfiles ~/.dotfiles
cd ~/.dotfiles
rake install
```

## Thanks

Large portions of this repository borrow heavily from [Zach Holman] (https://github.com/holman/dotfiles) and [Ryan Bates] (https://github.com/ryanb/dotfiles) excellent dotfile repositories: Zach's idea of organizing dotfiles into "topics" is very intuitive and Ryan's brilliant use of ERB templates for customized dotfiles, like .gitconfig, allows the repository to stay as generic as possible.

Most of the borrowed ideas and code manifest themselves in the installation process (and thus the Rakefile): I began with Zach's outstanding Rakefile and merged-in Ryan's support for ERB templates and identical file detection.
