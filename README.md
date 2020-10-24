# Dotfiles

My **personal** dotfiles used for my typical environment.

## Install

1. Git clone this repo

    ```sh
    git clone git@github.com:nickjer/dotfiles.git ~/.dotfiles
    ```

2. Run the bootstrap script included in this repo

    ```sh
    ~/.dotfiles/bootstrap.sh
    ```

## Update

1. Just run the bootstrap script again to apply updates

   ```sh
   ~/.dotfiles/bootstrap.sh
   ```

## Ubuntu Setup

If you are using Ubuntu as your local machine and want to replace Caps Lock
with Esc:

```sh
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"
```
