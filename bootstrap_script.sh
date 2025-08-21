#!/usr/bin/env bash

set -eo pipefail

mkdir -p ~/.local/bin

# Install fish if missing
if ! command -v fish &>/dev/null; then
  sudo apt-add-repository ppa:fish-shell/release-4
  sudo apt-get update
  sudo apt-get install fish
fi

# Install make if missing
if ! command -v make &>/dev/null; then
  sudo apt install -y make
fi

# Install curl if missing
if ! command -v curl &>/dev/null; then
  sudo apt install -y curl
fi

# Install tar if missing
if ! command -v tar &>/dev/null; then
  sudo apt install -y tar
fi

# Install openssl if missing
if ! command -v openssl &>/dev/null; then
  sudo apt install -y openssl
fi

# Install bzip2 if missing
if ! command -v bzip2 &>/dev/null; then
  sudo apt install -y bzip2
fi

# Install unzip if missing
if ! command -v unzip &>/dev/null; then
  sudo apt install -y unzip
fi

# Install patch if missing
if ! command -v patch &>/dev/null; then
  sudo apt install -y patch
fi

# Install gcc if missing
if ! command -v gcc &>/dev/null; then
  sudo apt install build-essential
fi

# Install xsel if missing
if ! command -v xsel &>/dev/null; then
  sudo apt install -y xsel
fi

# Install libfuse2 if missing
if [[ ! -f "/usr/lib/x86_64-linux-gnu/libfuse.so.2" ]]; then
  sudo apt install -y libfuse2
fi

# Copy over dotfiles
(
  cd src
  for FILE in $(find . -type f); do
    COPY_PATH="$(realpath -m -s "${HOME}/${FILE}")"
    mkdir -p "$(dirname "${COPY_PATH}")"

    ORIG_PATH="$(realpath "${FILE}")"
    if [[ ! -L "${COPY_PATH}" ]]; then
      if [[ -e "${COPY_PATH}" ]]; then
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
  local url="$(~/.local/bin/ghlast neovim neovim --output assets | grep 'x86_64\.appimage$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" &&
      curl -L "${url}" -s -S -f -o nvim &&
      chmod 755 nvim &&
      mv nvim ~/.local/bin
  )

  # Download/install starship
  echo "Downloading and installing 'starship'"
  local url="$(~/.local/bin/ghlast starship starship --output assets | grep 'x86.*musl.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" &&
      curl -L "${url}" | tar xz &&
      mv starship ~/.local/bin
  )
  rm -fr "${tmp}"

  # Download/install yayo
  echo "Downloading and installing 'yayo'"
  local url="$(~/.local/bin/ghlast nickjer yayo --output assets | grep 'x86.*musl.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" &&
      curl -L "${url}" | tar xz &&
      mv yayo ~/.local/bin
  )
  rm -fr "${tmp}"

  # Download/install fltn
  echo "Downloading and installing 'fltn'"
  local url="$(~/.local/bin/ghlast nickjer fltn --output assets | grep 'x86.*musl.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" &&
      curl -L "${url}" | tar xz &&
      mv fltn ~/.local/bin
  )
  rm -fr "${tmp}"

  # Download/install ripgrep
  echo "Downloading and installing 'ripgrep'"
  local url="$(~/.local/bin/ghlast BurntSushi ripgrep --output assets | grep 'x86.*musl.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" &&
      curl -L "${url}" | tar xz --strip-components=1 &&
      mv rg ~/.local/bin
  )
  rm -fr "${tmp}"

  # Download/install delta
  echo "Downloading and installing 'delta'"
  local url="$(~/.local/bin/ghlast dandavison delta --output assets | grep 'x86.*musl.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" &&
      curl -L "${url}" | tar xz --strip-components=1 &&
      mv delta ~/.local/bin
  )
  rm -fr "${tmp}"

  # Download/install xh
  echo "Downloading and installing 'xh'"
  local url="$(~/.local/bin/ghlast ducaale xh --output assets | grep 'x86.*musl.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" &&
      curl -L "${url}" | tar xz --strip-components=1 &&
      mv xh ~/.local/bin &&
      rm -f ~/.local/bin/xhs &&
      ln -s ~/.local/bin/xh ~/.local/bin/xhs
  )
  rm -fr "${tmp}"

  # Download/install fzf
  echo "Downloading and installing 'fzf'"
  local url="$(~/.local/bin/ghlast junegunn fzf --output assets | grep 'linux_amd64')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" &&
      curl -L "${url}" | tar xz &&
      mv fzf ~/.local/bin
  )
  rm -fr "${tmp}"

  # Download/install fd
  echo "Downloading and installing 'fd'"
  local url="$(~/.local/bin/ghlast sharkdp fd --output assets | grep 'x86.*gnu.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" &&
      curl -L "${url}" | tar xz --strip-components=1 &&
      mv fd ~/.local/bin
  )
  rm -fr "${tmp}"

  # Download/install bat
  echo "Downloading and installing 'bat'"
  local url="$(~/.local/bin/ghlast sharkdp bat --output assets | grep 'x86.*gnu.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" &&
      curl -L "${url}" | tar xz --strip-components=1 &&
      mv bat ~/.local/bin
  )
  rm -fr "${tmp}"

  # Download/install tldr
  echo "Downloading and installing 'tldr'"
  local url="$(~/.local/bin/ghlast dbrgn tealdeer --output assets | grep 'x86.*musl$')"
  curl -L "${url}" -o ~/.local/bin/tldr &&
    chmod 755 ~/.local/bin/tldr
  ~/.local/bin/tldr --update || true
  local url="$(~/.local/bin/ghlast dbrgn tealdeer --output assets | grep 'completions_fish')"
  mkdir -p ~/.config/fish/completions &&
    curl -L "${url}" -o ~/.config/fish/completions/tldr.fish

  # Download/install sd
  echo "Downloading and installing 'sd'"
  local url="$(~/.local/bin/ghlast chmln sd --output assets | grep 'x86.*musl')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" &&
      curl -L "${url}" | tar xz --strip-components=1 &&
      mv sd ~/.local/bin
  )
  rm -fr "${tmp}"

  # Download/install lsd
  echo "Downloading and installing 'lsd'"
  local url="$(~/.local/bin/ghlast lsd-rs lsd --output assets | grep 'x86.*gnu.*gz$')"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" &&
      curl -L "${url}" | tar xz --strip-components=1 &&
      mv lsd ~/.local/bin
  )
  rm -fr "${tmp}"

  # Download/install flameshot
  echo "Downloading and installing 'flameshot'"
  local url="$(~/.local/bin/ghlast flameshot-org flameshot --output assets | grep '\.AppImage$')"
  curl -L "${url}" -o ~/.local/bin/flameshot &&
    chmod 755 ~/.local/bin/flameshot
}

function installGhlast() {
  # Download/install ghlast (GitHub last release lookup tool)
  echo "Downloading and installing 'ghlast'"
  local api="https://api.github.com/repos/nickjer/ghlast/releases/latest"
  local url="$(curl --silent "${api}" | grep 'browser_download_url' | grep 'unknown-linux-musl' | cut --delimiter '"' --fields 4)"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" &&
      curl --location "${url}" | tar --extract --gzip &&
      mv ghlast ~/.local/bin
  )
  rm --force --recursive "${tmp}"
}

function installMise() {
  echo "Installing mise..."
  local url="$(~/.local/bin/ghlast jdx mise --output assets | grep 'linux-x64$')"
  curl -L "${url}" -o ~/.local/bin/mise &&
    chmod 755 ~/.local/bin/mise

  source <(~/.local/bin/mise activate bash)
}

function installRuby() {
  echo "Installing ruby..."
  mise use --global ruby
  echo "Done installing ruby!"
}

function installNode() {
  echo "Installing node..."
  mise use --global node@lts
  echo "Done installing node!"
}

function installYarn() {
  echo "Installing yarn..."
  npm install --global yarn
  echo "Done installing yarn!"
}

# Install GitHub last release lookup tool
installGhlast

# Install a tooling version manager
installMise

# Install ruby if missing
if ! command -v ruby &>/dev/null; then
  installRuby
fi

# Install node if missing
if ! command -v node &>/dev/null; then
  installNode
fi

# Install yarn if missing
if ! command -v yarn &>/dev/null; then
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
"${HOME}/.local/bin/nvim" --headless "+Lazy! sync" +qa
