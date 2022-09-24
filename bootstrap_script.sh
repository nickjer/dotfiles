#!/usr/bin/env bash

set -eo pipefail

mkdir -p ~/bin

# Install fish if missing
if ! command -v fish &> /dev/null ; then
  sudo apt-add-repository ppa:fish-shell/release-3
  sudo apt-get update
  sudo apt-get install fish
fi

# Install make if missing
if ! command -v make &> /dev/null ; then
  sudo apt install -y make
fi

# Install curl if missing
if ! command -v curl &> /dev/null ; then
  sudo apt install -y curl
fi

# Install tar if missing
if ! command -v tar &> /dev/null ; then
  sudo apt install -y tar
fi

# Install openssl if missing
if ! command -v openssl &> /dev/null ; then
  sudo apt install -y openssl
fi

# Install bzip2 if missing
if ! command -v bzip2 &> /dev/null ; then
  sudo apt install -y bzip2
fi

# Install patch if missing
if ! command -v patch &> /dev/null ; then
  sudo apt install -y patch
fi

# Install gcc if missing
if ! command -v gcc &> /dev/null ; then
  sudo apt install build-essential
fi

# Install xsel if missing
if ! command -v xsel &> /dev/null ; then
  sudo apt install -y xsel
fi

# Copy over dotfiles
(
  cd src
  for FILE in $(find . -type f) ; do
    COPY_PATH="$(realpath -m -s "${HOME}/${FILE}")"
    mkdir -p "$(dirname "${COPY_PATH}")"

    ORIG_PATH="$(realpath "${FILE}")"
    if [[ ! -L "${COPY_PATH}" ]] ; then
      if [[ -e "${COPY_PATH}" ]] ; then
        BACKUP_PATH="${COPY_PATH}.bak"
        echo "Backing up ${COPY_PATH} to ${BACKUP_PATH}"
        mv "${COPY_PATH}" "${BACKUP_PATH}"
      fi

      echo "Copying file ${ORIG_PATH}..."
      ln -s "${ORIG_PATH}" "${COPY_PATH}"
    fi
  done
)

function installTools() {
  # Download/install neovim
  echo "Downloading and installing 'neovim'"
  local url="$(~/bin/ghlast neovim neovim --output assets | grep 'appimage$')"
  curl -L "${url}" -s -S -f -o ~/bin/nvim && \
    chmod 755 ~/bin/nvim

  # Download/install starship
  echo "Downloading and installing 'starship'"
  local url="$(~/bin/ghlast starship starship --output assets | grep 'x86.*musl.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" | tar xz && \
      mv starship ~/bin
  )
  rm -fr "${tmp}"

  # Download/install yayo
  echo "Downloading and installing 'yayo'"
  local url="$(~/bin/ghlast nickjer yayo --output assets | grep 'x86.*gnu.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" | tar xz && \
      mv yayo ~/bin
  )
  rm -fr "${tmp}"

  # Download/install fltn
  echo "Downloading and installing 'fltn'"
  local url="$(~/bin/ghlast nickjer fltn --output assets | grep 'x86.*musl.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" | tar xz && \
      mv fltn ~/bin
  )
  rm -fr "${tmp}"

  # Download/install ripgrep
  echo "Downloading and installing 'ripgrep'"
  local url="$(~/bin/ghlast BurntSushi ripgrep --output assets | grep 'x86.*musl.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" | tar xz --strip-components=1 && \
      mv rg ~/bin
  )
  rm -fr "${tmp}"

  # Download/install delta
  echo "Downloading and installing 'delta'"
  local url="$(~/bin/ghlast dandavison delta --output assets | grep 'x86.*musl.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" | tar xz --strip-components=1 && \
      mv delta ~/bin
  )
  rm -fr "${tmp}"

  # Download/install xh
  echo "Downloading and installing 'xh'"
  local url="$(~/bin/ghlast ducaale xh --output assets | grep 'x86.*musl.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" | tar xz --strip-components=1 && \
      mv xh ~/bin && \
      rm -f ~/bin/xhs && \
      ln -s ~/bin/xh ~/bin/xhs
  )
  rm -fr "${tmp}"

  # Download/install fzf
  echo "Downloading and installing 'fzf'"
  local url="$(~/bin/ghlast junegunn fzf-bin --output assets | grep 'linux_amd64')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" | tar xz && \
      mv fzf ~/bin
  )
  rm -fr "${tmp}"

  # Download/install fd
  echo "Downloading and installing 'fd'"
  local url="$(~/bin/ghlast sharkdp fd --output assets | grep 'x86.*gnu.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" | tar xz --strip-components=1 && \
      mv fd ~/bin
  )
  rm -fr "${tmp}"

  # Download/install bat
  echo "Downloading and installing 'bat'"
  local url="$(~/bin/ghlast sharkdp bat --output assets | grep 'x86.*gnu.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" | tar xz --strip-components=1 && \
      mv bat ~/bin
  )
  rm -fr "${tmp}"

  # Download/install tldr
  echo "Downloading and installing 'tldr'"
  local url="$(~/bin/ghlast dbrgn tealdeer --output assets | grep 'x86.*musl$')"
  curl -L "${url}" -o ~/bin/tldr && \
    chmod 755 ~/bin/tldr
  ~/bin/tldr --update
  local url="$(~/bin/ghlast dbrgn tealdeer --output assets | grep 'completions_fish')"
  mkdir -p ~/.config/fish/completions && \
    curl -L "${url}" -o ~/.config/fish/completions/tldr.fish

  # Download/install jira
  echo "Downloading and installing 'jira'"
  local url="$(~/bin/ghlast go-jira jira --output assets | grep 'linux-amd64$')"
  curl -L "${url}" -o ~/bin/jira && \
    chmod 755 ~/bin/jira

  # Download/install sd
  echo "Downloading and installing 'sd'"
  local url="$(~/bin/ghlast chmln sd --output assets | grep 'x86.*musl$')"
  curl -L "${url}" -o ~/bin/sd && \
    chmod 755 ~/bin/sd

  # Download/install lsd
  echo "Downloading and installing 'lsd'"
  local url="$(~/bin/ghlast Peltoche lsd --output assets | grep 'x86.*gnu.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" | tar xz --strip-components=1 && \
      mv lsd ~/bin
  )
  rm -fr "${tmp}"
}

function installGhlast() {
  # Download/install ghlast (GitHub last release lookup tool)
  echo "Downloading and installing 'ghlast'"
  local api="https://api.github.com/repos/nickjer/ghlast/releases/latest"
  local url="$(curl --silent "${api}" | grep 'browser_download_url' | grep 'unknown-linux-musl' | cut --delimiter '"' --fields 4)"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl --location "${url}" | tar --extract --gzip && \
      mv ghlast ~/bin
  )
  rm --force --recursive "${tmp}"
}

function installChruby() {
  echo "Installing chruby..."
  local github="https://github.com/postmodern/chruby"
  local version="master"
  local url="${github}/archive/${version}.tar.gz"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}"
    curl -L "${url}" | tar xz --strip-components=1
    PREFIX="${HOME}/.chruby" make install
  )
  rm -fr "${tmp}"

  local github="https://github.com/JeanMertz/chruby-fish"
  local version="master"
  local url="${github}/archive/${version}.tar.gz"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}"
    curl -L "${url}" | tar xz --strip-components=1
    PREFIX="${HOME}/.chruby" make install
  )
  rm -fr "${tmp}"

  local github="https://github.com/postmodern/ruby-install"
  local version="master"
  local url="${github}/archive/${version}.tar.gz"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}"
    curl -L "${url}" | tar xz --strip-components=1
    PREFIX="${HOME}/.chruby" make install
  )
  rm -fr "${tmp}"
  echo "Done installing chruby!"

  source "$HOME/.chruby/share/chruby/chruby.sh"
  chruby ruby || true
}

function installRuby() {
  echo "Installing ruby..."
  export PATH="${HOME}/.chruby/bin:${PATH}"
  ruby-install --no-install-deps --latest ruby
  echo "Done installing ruby!"
}

function installFnm() {
  # Download/install node version manager
  echo "Downloading and installing 'fnm'"
  local url="$(~/bin/ghlast Schniz fnm --output assets | grep 'linux')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" -o fnm-linux.zip && \
      unzip fnm-linux.zip && \
      chmod 755 fnm && \
      mv fnm ~/bin
  )
  rm -fr "${tmp}"
  echo "Done installing fnm!"

  eval "$(~/bin/fnm env)"
}

function installNode() {
  echo "Installing node..."
  ~/bin/fnm install --lts
  echo "Done installing node!"
}

function installYarn() {
  echo "Installing yarn..."
  npm install --global yarn
  echo "Done installing yarn!"
}

# Install GitHub last release lookup tool
installGhlast

# Install a ruby version manager
installChruby

# Install ruby if missing
if ! command -v ruby &> /dev/null ; then
  installRuby
fi

# Install a node version manager
installFnm

# Install node if missing
if ! command -v node &> /dev/null ; then
  installNode
fi

# Install yarn if missing
if ! command -v yarn &> /dev/null ; then
  installYarn
fi

installTools

# Install fish plugins using the fisher tool
echo "Installing fish plugins..."
fish -c '
  curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher ;
  fisher install PatrickF1/fzf.fish
'

# Install vim plugins
echo "Bootstrapping vim..."
"${HOME}/bin/nvim" '+PlugUpgrade' '+PlugClean!' '+PlugUpdate' '+qall'

# Download/install coc.nvim extensions
"${HOME}/bin/nvim" \
  "+CocInstall -sync \
    coc-explorer \
    coc-fish \
    coc-git \
    coc-json \
    coc-pairs \
    coc-rust-analyzer \
    https://github.com/polypus74/trusty_rusty_snippets \
    coc-sh \
    coc-snippets \
    coc-solargraph" \
  '+qall'
