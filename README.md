# Dotfiles

My **personal** dotfiles used for my typical environment.

## Install

1. Install https://github.com/Bash-it/bash-it

    ```sh
    git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
    ```

2. Git clone this repo

    ```sh
    git clone git@github.com:nickjer/dotfiles.git .dotfiles
    ```

3. Move contents of repo into `$HOME`

    ```sh
    .dotfiles/bootstrap.sh
    ```

4. Install https://github.com/junegunn/vim-plug

    ```sh
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +PlugInstall
    ```


## Update

### dotfiles

```sh
~/.dotfiles/bootstrap.sh
```

### vim-plug

```sh
vim +PlugUpgrade +PlugUpdate
```

### bash_it

```sh
bash-it update
```
