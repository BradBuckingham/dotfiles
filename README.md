# Brad's dotfiles

These dotfiles are designed to work well in both OSX and Linux.

## Installation dependencies

* git
* ruby

## Install

```bash
$ git clone git@github.com:BradBuckingham/dotfiles.git ~/.dotfiles
$ cd ~/.dotfiles
$ ruby setup.rb
```

## Update

```bash
$ cd ~/.dotfiles
$ ruby setup.rb update
```
## Uninstall

```bash
$ cd ~/.dotfiles
$ ruby setup.rb uninstall
```

## Thanks

Large portions of this repository borrow heavily from [Zach Holman](https://github.com/holman/dotfiles) and [Ryan Bates](https://github.com/ryanb/dotfiles) excellent dotfile repositories: Zach's idea of organizing dotfiles into "topics" is very intuitive and Ryan's brilliant use of ERB templates for customized dotfiles, like .gitconfig, allows the repository to stay as generic as possible.

Most of the borrowed ideas and code manifest themselves in the installation process: I began with Zach's outstanding Rakefile and merged-in Ryan's support for ERB templates and identical file detection.

## Tips

### Local overrides (not stored in the repository)

* zshrc: `~/.zshrc.before` and `~/.zshrc.after`

### Convert Linux's gnome-terminal to Solarized color palette

* Edit the default profile's 16 colors (in [this](http://curtisfree.com/blog/2012/03/24/convert_gnome_terminal_colors_x_resources#get-your-colors-from-gnome-terminal) order) to match the [Solarized palette](https://github.com/altercation/solarized/blob/master/xresources-colors-solarized/Xresources)

### My OSX setup (after a clean install of OSX)

1. Install [iTerm2](https://iterm2.com/)
2. Install XCode CLI tools (includes git, etc): `sudo xcode-select`
3. Install these dotfiles ;)
4. Switch to ZSH: `chsh -s /bin/zsh`
5. Install [homebrew](https://brew.sh/)

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

### Removing a git submodule

1. Delete the relevant line from the `.gitmodules` file.
2. Delete the relevant section from `.git/config`.
3. Run `git rm --cached path_to_submodule` (no trailing slash).
4. Commit and delete the now untracked submodule files.

_Source: [Stack Overflow](http://stackoverflow.com/a/1260982)_
