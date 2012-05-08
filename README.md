# Brad's dotfiles

These dotfiles are designed to work well in both OSX and Linux.

## Installation dependencies

* git
* rake (and thus ruby)

## Install

```bash
$ git clone --recursive git://github.com/BradBuckingham/dotfiles ~/.dotfiles
$ cd ~/.dotfiles
$ rake install
```

## Thanks

Large portions of this repository borrow heavily from [Zach Holman](https://github.com/holman/dotfiles) and [Ryan Bates](https://github.com/ryanb/dotfiles) excellent dotfile repositories: Zach's idea of organizing dotfiles into "topics" is very intuitive and Ryan's brilliant use of ERB templates for customized dotfiles, like .gitconfig, allows the repository to stay as generic as possible.

Most of the borrowed ideas and code manifest themselves in the installation process (and thus the Rakefile): I began with Zach's outstanding Rakefile and merged-in Ryan's support for ERB templates and identical file detection.

## Tips

### Local overrides (not stored in the repository)

* zshrc: `~/.zshrc.before` and `~/.zshrc.after`

### My OSX setup (after a clean install of OSX)

1. Install these dotfiles ;)
2. Switch to ZSH: `chsh -s /bin/zsh`
3. Install [XCode CLI tools](https://developer.apple.com/downloads)
4. Install [homebrew](https://github.com/mxcl/homebrew/wiki/installation)
5. Install [RVM](https://rvm.io/):
   * Install any dependencies listed in `rvm requirements`
   * 1.9.3 MRI (make system default)


### Installing a new Vim plugin as a git submodule

```bash
$ cd ~/.dotfiles
$ git submodule add <git repo URL> vim/vim.symlink/bundle/<name of plugin>
$ git commit -m "Installed Vim plugin <plugin> as a submodule"
```

_Source: [Drew Neil's](http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/) fabulous Vimcasts_

### Updating a Vim plugin installed as a git submodule

```bash
$ cd ~/.dotfiles/vim/vim.symlink/bundle/<name of plugin>
$ git pull origin master
$ git commit -m "Updated Vim plugin <plugin>"
```

_Source: [Drew Neil's](http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/) fabulous Vimcasts_

### Updating all Vim plugins installed as git submodules

```bash
$ git submodule foreach git pull origin master
$ git commit -m "Updated all Vim plugins"
```

_Source: [Drew Neil's](http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/) fabulous Vimcasts_
