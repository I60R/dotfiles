# Overview

Each configuration is tracked on its own branch. This makes them independent from each other. At the same time it's possible to checkout multiple branches.
And such workflow is possible with the help of three git aliases:

* `git focus branch` - literally `checkout` without removing files from working tree
* `git setup set` - picks all files from all branches prefixed with `set/*`
* `git track remote` - creates tracking `branch` for each `remote/branch`


**Be careful: don't run commands unless you completely understand what consequences might happen**


# Init

```sh
    cd ~
    git init
    mkdir -p .config/git
    mv .gitconfig .config/git/gitconfig || touch .config/git/gitconfig
    ln -s .config/git/gitconfig .gitconfig
    git config alias.focus '!f() { git symbolic-ref HEAD refs/heads/$1 && git reset; }; f'
    git config alias.setup '!f(){ for s in $@; do for b in $(git branch --list "*$s/*"); do git checkout $b -- .; echo "+$b"; done; done; }; f'
    git config alias.track '!f(){ for b in $(git branch -r | grep \"$1/\" | sed \"s/$1\\///g\"); do git branch --track $b $1/$b; done; }; f'
    git add .gitconfig # Add other files that should be shared among branches (e.g. README.md)
    git commit -m "initial configuration"
    git branch -m workspace # [ALWAYS] keep this branch pointed to initial commit
```

# To add config

```sh
    git focus workspace
    git checkout -b cfg/git # This is the name of config branch, cfg/ part is optional
    git add .config/git/gitconfig # Add other files that belongs to git
    git status # [ALWAYS] review your changes before committing
    git commit -m "new config: cfg/git"
```

# To push added config

```sh
    git remote add origin git:service.url:user/repository # This is required only at first time
    git focus cfg/git
    git push -u origin cfg/git # `-u` is short for `--set-upstream-to=`
```

# To pull it on other machine

```sh
    cd ~
    git init
    git remote add origin git:service.url:user/repository
    git fetch --all
    git track origin
    git focus cfg/git && git diff # [ALWAYS] ensure that you ready to replace local files
    git setup cfg/git # This will pull all files from `cfg/*` branches into working tree
```

# To setup only specific set of branches

```sh
    git focus cfg/git
    git checkout -b work/git
    git config --global user.name "officialname" # Alias you use at work
    git config --global user.email "officialname@work.com" # Email you use at work
    git add -u # `-u` is short for `--update`, works for tracked files only (.config/git/gitconfig in this example)
    git commit -m "new set: work/git"
    git push -u origin work/git # To push created set

    # On other computer:

    git fetch origin cfg/git work/git
    git setup cfg # First set up generic configuration
    git setup work # Then apply work-specific settings
```

