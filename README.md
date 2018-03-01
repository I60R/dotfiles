# Overview

Each configuration is tracked on its own branch.
That's possible with the help of three git aliases:

* `git switch branch` - literally `checkout` that keeps tracked files in working tree
* `git setup set` - picks files from all branches prefixed with `set/*`
* `git track remote` - creates tracking local `branch` for each `remote/branch`


**Be careful - don't run commands, until you don't understand consequences**


# To get initial setup

```sh
    cd ~
    git init
    mkdir -p .config/git
    mv .gitconfig .config/git/gitconfig || touch .config/git/gitconfig
    ln -s .config/git/gitconfig .gitconfig
    git config alias.switch '!f() { git symbolic-ref HEAD refs/heads/$1 && git reset; }; f'
    git config alias.setup '!f(){ for s in $@; do for b in $(git branch --list "*$s/*"); do git checkout $b -- .; echo "+$b"; done; done; }; f'
    git config alias.track '!f(){ for b in $(git branch -r | grep \"$1/\" | sed \"s/$1\\///g\"); do git branch --track $b $1/$b; done; }; f'
    git add .gitconfig # Also you can add other files that need's to be shared on all branches (e.g. README)
    git commit -m "initial configuration"
    git branch -m workspace # This will help you in future
```

# To add config

```sh
    git switch workspace # This branch should always point to initial commit in repository
    git checkout -b cfg/git
    git add .config/git/gitconfig
    git status # Don't forget to review your changes
    git commit -m "new config: cfg/git"
```

# To publish your changes

```sh
    git remote add origin git:service.url:user/repository
    git switch cfg/git
    git push -u origin cfg/git # Where `-u` is short for `--set-upstream-to=`, creates and tracks remote branch
```

# To obtain changes

```sh
    cd ~
    git init
    git remote add origin git:service.url:user/repository
    git fetch --all
    git track origin # This will create local branches that tracks origin/branches
    git switch cfg/git && git diff # Review what should be overwritten and backup important stuff. Do it for each remote branch
    git setup cfg # This will checkout all files from `cfg/*` branches into working tree
```

# To apply config set

```sh
    git switch cfg/git
    git checkout -b work/git
    git config --global user.name "officialname" # Alias you use on work
    git config --global user.email "officialname@work.com" # Email you use on work
    git add -u # `-u` is short for `--update`. It updates tracked files only (.config/git/gitconfig in this example)
    git commit -m "new set: work/git"
    git push -u origin work/git # To push created set

    # On other computer:

    git fetch origin cfg/git work/git
    git setup cfg # First set up generic configuration
    git setup work # Then apply work-specific settings
```

