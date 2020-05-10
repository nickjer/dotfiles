#/usr/bin/env bash

set -exo pipefail

# Install make if missing
if ! command -v make &> /dev/null ; then
  sudo apt install -y make
fi

# Install curl if missing
if ! command -v curl &> /dev/null ; then
  sudo apt install -y curl
fi

# Install xsel if missing
if ! command -v xsel &> /dev/null ; then
  sudo apt install -y xsel
fi

# Install bash-it if missing
BASH_IT="${HOME}/.bash_it"
if [[ ! -f "${BASH_IT}/bash_it.sh" ]] ; then
  echo "Installing bash-it..."
  git clone --depth=1 https://github.com/Bash-it/bash-it.git "${BASH_IT}"
  "${BASH_IT}/install.sh" --silent
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

set +exo
source "${BASH_IT}/bash_it.sh"
set -exo pipefail

# Install neovim if missing
if ! command -v nvim &> /dev/null ; then
  echo "Installing neovim..."
  sudo apt-get update
  sudo apt-get install -y software-properties-common

  sudo add-apt-repository -y ppa:neovim-ppa/unstable
  sudo apt-get update
  sudo apt-get install -y neovim
fi

# Set neovim as default vim command
VIM_CMD="${HOME}/bin/vim"
if [[ ! -f "${VIM_CMD}" ]] ; then
  echo "Setting neovim as default vim command..."
  mkdir -p "$(dirname "${VIM_CMD}")"
  echo $'#!/usr/bin/env bash\n\nexec nvim "${@}"' > "${VIM_CMD}"
  chmod 755 "${VIM_CMD}"
fi

function doIt() {
  set +exo
  # Enable bash helpers
  bash-it enable alias \
    bundler \
    curl \
    docker \
    docker-compose \
    general \
    git \
    vim
  bash-it enable plugin \
    alias-completion \
    base \
    docker-compose \
    docker \
    edit-mode-vi \
    fzf \
    git \
    history \
    nvm
  bash-it enable completion \
    bash-it \
    bundler \
    docker \
    docker-compose \
    gem \
    git \
    npm \
    nvm \
    rake \
    system
  set -exo pipefail

  # Download/install coc.nvim extensions
  (
    cd "${HOME}/.config/coc/extensions"
    yarn install
  )

  # Download/install starship
  echo "Downloading and installing 'starship'"
  local github="$(githubUrl starship starship)"
  local version="$(getVersion "${github}")"
  local url="${github}/releases/download/${version}/starship-x86_64-unknown-linux-gnu.tar.gz"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" | tar xz && \
      mv starship ~/bin
  )
  rm -fr "${tmp}"

  # Download/install ripgrep
  echo "Downloading and installing 'ripgrep'"
  local github="$(githubUrl BurntSushi ripgrep)"
  local version="$(getVersion "${github}")"
  local url="${github}/releases/download/${version}/ripgrep-${version}-x86_64-unknown-linux-musl.tar.gz"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" | tar xz --strip-components=1 && \
      mv rg ~/bin
  )
  rm -fr "${tmp}"

  # Download/install fzf
  echo "Downloading and installing 'fzf'"
  local github="$(githubUrl junegunn fzf-bin)"
  local version="$(getVersion "${github}")"
  local url="${github}/releases/download/${version}/fzf-${version}-linux_amd64.tgz"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" | tar xz && \
      mv fzf ~/bin
  )
  rm -fr "${tmp}"

  # Download/install fzf scripts
  echo "Downloading and installing 'fzf scripts'"
  local github="$(githubUrl junegunn fzf)"
  local url="${github}/archive/master.tar.gz"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" | tar xz --strip-components=1 && \
      cat shell/completion.bash shell/key-bindings.bash > ~/.fzf.bash
  )
  rm -fr "${tmp}"

  # Download/install fd
  echo "Downloading and installing 'fd'"
  local github="$(githubUrl sharkdp fd)"
  local version="$(getVersion "${github}")"
  local url="${github}/releases/download/${version}/fd-${version}-x86_64-unknown-linux-gnu.tar.gz"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" | tar xz --strip-components=1 && \
      mv fd ~/bin
  )
  rm -fr "${tmp}"

  # Download/install bat
  echo "Downloading and installing 'bat'"
  local github="$(githubUrl sharkdp bat)"
  local version="$(getVersion "${github}")"
  local url="${github}/releases/download/${version}/bat-${version}-x86_64-unknown-linux-gnu.tar.gz"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}" && \
      curl -L "${url}" | tar xz --strip-components=1 && \
      mv bat ~/bin
  )
  rm -fr "${tmp}"

  # Download/install tldr
  echo "Downloading and installing 'tldr'"
  local github="$(githubUrl dbrgn tealdeer)"
  local version="$(getVersion "${github}")"
  local url="${github}/releases/download/${version}/tldr-linux-x86_64-musl"
  curl -L "${url}" -o ~/bin/tldr && \
    chmod 755 ~/bin/tldr

  # Download/install jira
  echo "Downloading and installing 'jira'"
  local github="$(githubUrl go-jira jira)"
  local version="$(getVersion "${github}")"
  local url="${github}/releases/download/${version}/jira-linux-amd64"
  curl -L "${url}" -o ~/bin/jira && \
    chmod 755 ~/bin/jira
}

function githubUrl {
  local account="${1}"
  local project="${2}"
  echo "https://github.com/${account}/${project}"
}

function getVersion() {
  local github="${1}"
  local json="$(curl -L -s -H 'Accept: application/json' ${github}/releases/latest)"
  # The releases are returned in the format:
  #     {"id":3622206,"tag_name":"hello-1.0.0.11",...}
  # we have to extract the tag_name.
  echo "$(echo "${json}" | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')"
}

function installChruby() {
  echo "Installing chruby..."
  local github="$(githubUrl postmodern chruby)"
  local version="master"
  local url="${github}/archive/${version}.tar.gz"
  local tmp="$(mktemp -d)"
  (
    cd "${tmp}"
    curl -L "${url}" | tar xz --strip-components=1
    PREFIX="${HOME}/.chruby" make install
  )
  rm -fr "${tmp}"

  local github="$(githubUrl postmodern ruby-install)"
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
}

function installRuby() {
  echo "Installing ruby..."
  export PATH="${HOME}/.chruby/bin:${PATH}"
  ruby-install ruby 2.7
  echo "Done installing ruby!"
}

function installNvm() {
  echo "Installing nvm..."
  local github="$(githubUrl nvm-sh nvm)"
  local version="$(getVersion "${github}")"
  local url="${github}/archive/${version}.tar.gz"
  local tmp="$(mktemp -d)"
  (
    export PROFILE=/dev/null
    cd "${tmp}"
    curl -L "${url}" | tar xz --strip-components=1 && bash install.sh
  )
  rm -fr "${tmp}"
  echo "Done installing nvm!"
}

function installNode() {
  echo "Installing node..."
  export NVM_DIR="${HOME}/.nvm"
  source "${NVM_DIR}/nvm.sh"
  nvm install --lts
  echo "Done installing node..."
}

function installYarn() {
  echo "Installing yarn..."
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

  sudo apt update && sudo apt install --no-install-recommends -y yarn
  echo "Done installing yarn!"
}

# Install chruby if missing
if [[ ! -d "${HOME}/.chruby" ]] ; then
  installChruby
fi

# Install ruby if missing
if ! command -v ruby &> /dev/null ; then
  installRuby
fi

# Install nvm if missing
if [[ ! -d "${HOME}/.nvm" ]] ; then
  installNvm
fi

# Install node if missing
if ! command -v node &> /dev/null ; then
  installNode
fi

# Install yarn if missing
if ! command -v yarn &> /dev/null ; then
  installYarn
fi

doIt

# Install vim plugins
echo "Bootstrapping vim..."
nvim '+PlugUpdate' '+PlugClean!' '+PlugUpdate' '+qall'
