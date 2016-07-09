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

4. Install https://github.com/spf13/spf13-vim

    ```sh
    sh <(curl https://j.mp/spf13-vim3 -L)
    ```


## Update

### dotfiles

```sh
~/.dotfiles/bootstrap.sh
```

### spf13-vim

```sh
curl https://j.mp/spf13-vim3 -L -o - | sh
```

### bash_it

```sh
bash-it update
```
