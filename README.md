# Brad's dotfiles

## Installation dependencies

* rake (and thus ruby)

## Install

```
git clone --recursive git://github.com/BradBuckingham/dotfiles ~/.dotfiles
cd ~/.dotfiles
rake install
```

## Thanks

Large portions of this repository borrow heavily from [Zach Holman](https://github.com/holman/dotfiles) and [Ryan Bates](https://github.com/ryanb/dotfiles) excellent dotfile repositories: Zach's idea of organizing dotfiles into "topics" is very intuitive and Ryan's brilliant use of ERB templates for customized dotfiles, like .gitconfig, allows the repository to stay as generic as possible.

Most of the borrowed ideas and code manifest themselves in the installation process (and thus the Rakefile): I began with Zach's outstanding Rakefile and merged-in Ryan's support for ERB templates and identical file detection.

## Tips

### Installing a new Vim plugin as a git submodule

```
cd ~/.dotfiles
git submodule add <git repo URL> bundle/<name of plugin>
git commit -m "Installed Vim plugin <plugin> as a submodule"
```

*Source: [Drew Neil](http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/)'s fabulous Vimcasts*

### Updating a Vim plugin installed as a git submodule

```
cd ~/.dotfiles/vim/vim.symlink/bundle/<name of plugin>
git pull origin master
git commit -m "Updated Vim plugin <plugin>"
```

*Source: [Drew Neil](http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/)'s fabulous Vimcasts*

### Updating all Vim plugins installed as git submodules

```
git submodule foreach git pull origin master
git commit -m "Updated all Vim plugins"
```

*Source: [Drew Neil](http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/)'s fabulous Vimcasts*
