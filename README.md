# Dotfiles

My **personal** dotfiles used for my typical environment.

## Install

1. Install https://github.com/spf13/spf13-vim

    ```sh
    sh <(curl https://j.mp/spf13-vim3 -L)
    ```

2. Install https://github.com/Bash-it/bash-it

    ```sh
    git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
    ```

3. Git clone this repo

    ```sh
    git clone git@github.com:nickjer/dotfiles.git
    ```

4. Move contents of repo into `$HOME`

    ```sh
    # be sure to move hidden files as well
    shopt -s dotglob
    mv dotfiles/* .
    rmdir dotfiles
    ```

## Update

### dotfiles

```sh
cd ~
git pull
```

### spf13-vim

```sh
curl https://j.mp/spf13-vim3 -L -o - | sh
```

### bash_it

```sh
bash-it update
```

## Gotchas

### bash_it

If you add a new alias, completion, or plugin please add the symlink directly
to this repo, e.g.:

```sh
git add -f .bash_it/aliases/enabled/<ALIAS>.aliases.bash
```
