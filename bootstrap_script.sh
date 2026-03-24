#!/usr/bin/env bash

set -o pipefail

mkdir -p ~/.local/bin

FAILURES=()

# ============================================================
# Helpers
# ============================================================

log_section() { printf "\n\033[1;34m==>\033[0m \033[1m%s\033[0m\n" "$1"; }
log_ok()      { printf "  \033[1;32m[OK]\033[0m %s\n" "$1"; }
log_fail()    { printf "  \033[1;31m[FAIL]\033[0m %s — %s\n" "$1" "$2"; FAILURES+=("$1"); }
log_skip()    { printf "  \033[33m[SKIP]\033[0m %s\n" "$1"; }

# Download a tarball, extract it, find a binary by name, and install it.
# Usage: install_from_tarball <name> <url> <binary> [<dest>]
install_from_tarball() {
  local name="$1" url="$2" binary="$3" dest="${4:-$3}"
  local tmp bin_path

  tmp="$(mktemp -d)"
  if curl -fsSL "$url" | tar xz -C "$tmp"; then
    bin_path="$(find "$tmp" -name "$binary" -type f | head -1)"
    if [[ -n "$bin_path" ]]; then
      mv "$bin_path" ~/.local/bin/"$dest"
      chmod 755 ~/.local/bin/"$dest"
      rm -fr "$tmp"
      log_ok "$name"
      return 0
    fi
    log_fail "$name" "binary '$binary' not found in archive"
  else
    log_fail "$name" "download or extraction failed"
  fi
  rm -fr "$tmp"
  return 1
}

# Resolve a GitHub release asset URL via ghlast and install the binary.
# Detects tarballs (.tar.gz/.tgz) vs direct binary downloads automatically.
# Usage: gh_install <name> <owner> <repo> <asset_pattern> <binary> [<dest>]
gh_install() {
  local name="$1" owner="$2" repo="$3" pattern="$4" binary="$5" dest="${6:-$5}"
  local url

  url="$(~/.local/bin/ghlast "$owner" "$repo" --output assets | grep "$pattern")"
  if [[ -z "$url" ]]; then
    log_fail "$name" "no matching release asset"
    return 1
  fi

  if [[ "$url" =~ \.(tar\.gz|tgz)$ ]]; then
    install_from_tarball "$name" "$url" "$binary" "$dest"
  elif curl -fsSL "$url" -o ~/.local/bin/"$dest"; then
    chmod 755 ~/.local/bin/"$dest"
    log_ok "$name"
  else
    log_fail "$name" "download failed"
    return 1
  fi
}

# Bootstrap ghlast via the GitHub API (can't use ghlast to install itself)
installGhlast() {
  local api="https://api.github.com/repos/nickjer/ghlast/releases/latest"
  local url

  url="$(curl -fsSL "$api" | grep 'browser_download_url' | grep 'unknown-linux-musl' | cut -d '"' -f 4)"
  if [[ -z "$url" ]]; then
    log_fail "ghlast" "failed to resolve download URL"
    return 1
  fi
  install_from_tarball "ghlast" "$url" "ghlast"
}

# Install tldr (tlrc) with fish completions
installTldr() {
  local url tmp

  url="$(~/.local/bin/ghlast tldr-pages tlrc --output assets | grep 'x86.*musl.*gz$')"
  if [[ -z "$url" ]]; then
    log_fail "tldr" "no matching release asset"
    return 1
  fi

  tmp="$(mktemp -d)"
  if curl -fsSL "$url" | tar xz -C "$tmp"; then
    local bin_path comp_path
    bin_path="$(find "$tmp" -name "tldr" -type f | head -1)"
    if [[ -n "$bin_path" ]]; then
      mv "$bin_path" ~/.local/bin/tldr
      chmod 755 ~/.local/bin/tldr
      comp_path="$(find "$tmp" -name "tldr.fish" -type f | head -1)"
      if [[ -n "$comp_path" ]]; then
        mkdir -p ~/.config/fish/completions
        mv "$comp_path" ~/.config/fish/completions/
      fi
      rm -fr "$tmp"
      log_ok "tldr"
      ~/.local/bin/tldr --update &>/dev/null || true
      return 0
    fi
    log_fail "tldr" "binary not found in archive"
  else
    log_fail "tldr" "download or extraction failed"
  fi
  rm -fr "$tmp"
  return 1
}

# ============================================================
# Main
# ============================================================

# --- Detect package manager ---

if command -v pacman &>/dev/null; then
  PKG_MANAGER="pacman"
elif command -v dnf &>/dev/null; then
  PKG_MANAGER="dnf"
elif command -v apt &>/dev/null; then
  PKG_MANAGER="apt"
else
  echo "Unsupported package manager"
  exit 1
fi

# --- Install system packages ---

log_section "Installing system packages ($PKG_MANAGER)"

if [[ "$PKG_MANAGER" == "pacman" ]]; then
  sudo pacman -S --noconfirm --needed base-devel

elif [[ "$PKG_MANAGER" == "dnf" ]]; then
  if ! command -v fish &>/dev/null; then
    sudo dnf install -y fish
  fi

  sudo dnf install -y \
    autoconf gcc rust patch make bzip2 \
    openssl-devel libyaml-devel libffi-devel readline-devel \
    zlib-ng-compat-devel gdbm-devel ncurses-devel perl-FindBin

  for cmd in curl tar unzip; do
    if ! command -v "$cmd" &>/dev/null; then
      sudo dnf install -y "$cmd"
    fi
  done

  if ! command -v wl-copy &>/dev/null; then
    sudo dnf install -y wl-clipboard
  fi

  if [[ ! -f "/usr/lib64/libfuse.so.2" ]]; then
    sudo dnf install -y fuse-libs
  fi

elif [[ "$PKG_MANAGER" == "apt" ]]; then
  if ! command -v fish &>/dev/null; then
    sudo apt-add-repository ppa:fish-shell/release-4
    sudo apt-get update
    sudo apt-get install -y fish
  fi

  for cmd in make curl tar openssl bzip2 unzip patch xsel; do
    if ! command -v "$cmd" &>/dev/null; then
      sudo apt install -y "$cmd"
    fi
  done

  if ! command -v gcc &>/dev/null; then
    sudo apt install -y build-essential
  fi

  if [[ ! -f "/usr/lib/x86_64-linux-gnu/libfuse.so.2" ]]; then
    sudo apt install -y libfuse2
  fi
fi

# --- Symlink dotfiles ---

log_section "Symlinking dotfiles"

(
  cd src
  for FILE in $(find . -type f); do
    COPY_PATH="$(realpath -m -s "${HOME}/${FILE}")"
    DISPLAY_PATH="${COPY_PATH#"$HOME"/}"
    mkdir -p "$(dirname "${COPY_PATH}")"

    ORIG_PATH="$(realpath "${FILE}")"
    if [[ -L "${COPY_PATH}" ]]; then
      log_skip "$DISPLAY_PATH"
    else
      if [[ -e "${COPY_PATH}" ]]; then
        mv "${COPY_PATH}" "${COPY_PATH}.bak"
      fi
      ln -s "${ORIG_PATH}" "${COPY_PATH}"
      log_ok "$DISPLAY_PATH"
    fi
  done
)

# --- Install ghlast (required for all GitHub downloads) ---

log_section "Installing ghlast"
installGhlast || exit 1

# --- Install mise ---

log_section "Installing mise"

if [[ "$PKG_MANAGER" == "pacman" ]]; then
  sudo pacman -S --noconfirm --needed mise
  source <(mise activate bash)
  log_ok "mise"
else
  if gh_install "mise" jdx mise 'linux-x64$' mise; then
    source <(~/.local/bin/mise activate bash)
  else
    exit 1
  fi
fi

# --- Install languages ---

log_section "Installing languages"

if command -v ruby &>/dev/null; then
  log_skip "ruby"
elif mise use --global ruby; then
  log_ok "ruby"
else
  log_fail "ruby" "mise install failed"
fi

if command -v node &>/dev/null; then
  log_skip "node"
elif mise use --global node@lts; then
  log_ok "node"
else
  log_fail "node" "mise install failed"
fi

if command -v yarn &>/dev/null; then
  log_skip "yarn"
elif npm install --global yarn &>/dev/null; then
  log_ok "yarn"
else
  log_fail "yarn" "npm install failed"
fi

# --- Install tools ---

log_section "Installing tools"

gh_install "neovim"   neovim      neovim   'x86_64\.appimage$'  nvim
gh_install "yayo"     nickjer     yayo     'x86.*musl.*gz$'     yayo
gh_install "fltn"     nickjer     fltn     'x86.*musl.*gz$'     fltn
gh_install "jira-cli" ankitpokhrel jira-cli 'linux_x86_64'      jira

if [[ "$PKG_MANAGER" == "pacman" ]]; then
  log_section "Installing tools via pacman"
  sudo pacman -S --noconfirm --needed \
    starship ripgrep git-delta xh fzf fd bat tlrc sd lsd
else
  gh_install "starship" starship   starship 'x86.*musl.*gz$'    starship
  gh_install "ripgrep"  BurntSushi ripgrep  'x86.*musl.*gz$'    rg
  gh_install "delta"    dandavison delta    'x86.*musl.*gz$'    delta
  gh_install "fzf"      junegunn   fzf      'linux_amd64'       fzf
  gh_install "fd"       sharkdp    fd       'x86.*gnu.*gz$'     fd
  gh_install "bat"      sharkdp    bat      'x86.*gnu.*gz$'     bat
  gh_install "sd"       chmln      sd       'x86.*musl'         sd
  gh_install "lsd"      lsd-rs     lsd      'x86.*gnu.*gz$'     lsd

  gh_install "xh" ducaale xh 'x86.*musl.*gz$' xh && {
    rm -f ~/.local/bin/xhs
    ln -s ~/.local/bin/xh ~/.local/bin/xhs
  }

  installTldr
fi

# --- Install fish plugins ---

log_section "Installing fish plugins"

if fish -c '
  curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
  fisher install PatrickF1/fzf.fish
' &>/dev/null; then
  log_ok "fisher + fzf.fish"
else
  log_fail "fish plugins" "fisher install failed"
fi

# --- Bootstrap neovim ---

log_section "Bootstrapping neovim"

if "${HOME}/.local/bin/nvim" --headless "+Lazy! sync" +qa &>/dev/null; then
  log_ok "neovim plugins"
else
  log_fail "neovim plugins" "Lazy sync failed"
fi

# --- Summary ---

echo ""
if [[ ${#FAILURES[@]} -gt 0 ]]; then
  log_section "Done with ${#FAILURES[@]} error(s)"
  for f in "${FAILURES[@]}"; do
    printf "  - %s\n" "$f"
  done
  exit 1
else
  log_section "Bootstrap complete!"
fi
