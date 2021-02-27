# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export QT_AUTO_SCREEN_SCALE_FACTOR=1

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes rbenv's private bin if it exists
if [ -d "$HOME/.chruby" ] ; then
  PATH="$HOME/.chruby/bin:$PATH"
  . "$HOME/.chruby/share/chruby/chruby.sh"
  # . "$HOME/.chruby/share/chruby/auto.sh"
  chruby ruby
fi

# set PATH so it includes yarn's private bin if it exists
if [ -d "$HOME/.yarn/bin" ] ; then
  PATH="$HOME/.yarn/bin:$PATH"
fi

# set PATH so it includes cargo's private bin if it exists
if [ -d "$HOME/.cargo" ] ; then
  PATH="$HOME/.cargo/bin:$PATH"
fi
