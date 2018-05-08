#/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
  # Copy over contents
  rsync --exclude ".git/" \
      --exclude "bootstrap.sh" \
      --exclude "README.md" \
      --exclude ".gitkeep" \
      -avh --no-perms . ~ \
    && bash-it enable aliases \
      bundler \
      curl \
      docker \
      docker-compose \
      general \
      git \
      vim \
    && bash-it enable plugins \
      alias-completion \
      base \
      docker-compose \
      docker \
      edit-mode-vi \
      git \
      history \
    && bash-it enable completions \
      bash-it \
      bundler \
      docker \
      docker-compose \
      gem \
      git \
      npm \
      rake \
      system

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

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt;
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt;
  fi;
fi;
unset doIt;
