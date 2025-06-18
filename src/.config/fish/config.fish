# set PATH so it includes user's private bin if it exists
fish_add_path ~/bin

# mise
if command -v mise &> /dev/null
  mise activate fish | source
end

# yarn
fish_add_path ~/.yarn/bin

# cargo
fish_add_path ~/.cargo/bin

# yayo
if command -v yayo &> /dev/null
  yayo completion fish | source
end

# Fix issue with QT applications and scaling
set -x QT_AUTO_SCREEN_SCALE_FACTOR 1

# Disable spring if used in Ruby project
set -x DISABLE_SPRING true

# Set editor
set -x EDITOR nvim

# Ignore pry in Rails projects
set -x DISABLE_PRY_RAILS 1

# Set BP app root
set -x BP_APP_ROOT $HOME/Development

# Set GitHub token
if test -z "$PKG_GITHUB_COM_TOKEN"
  set -x PKG_GITHUB_COM_TOKEN ""
end

# Vim keybindings
fish_vi_key_bindings

# Starship prompt
starship init fish | source

# Define abbreviations
if status --is-interactive
  abbr --add --global vim 'nvim'
  abbr --add --global open 'xdg-open &> /dev/null'

  # bundle
  abbr --add --global bi 'bundle install'
  abbr --add --global be 'bundle exec'

  # git
  abbr --add --global ga 'git add'
  abbr --add --global gb 'git branch'
  abbr --add --global gc 'git commit --verbose'
  abbr --add --global gcm 'git commit --verbose --message'
  abbr --add --global gco 'git checkout'
  abbr --add --global gcb 'git checkout -b'
  abbr --add --global gd 'git diff'
  abbr --add --global gl 'git pull'
  abbr --add --global gp 'git push'
  abbr --add --global gs 'git status'
  abbr --add --global gg 'git log --graph --pretty=format:'\''%C(bold)%h%Creset%C(magenta)%d%Creset %s %C(yellow)<%an> %C(cyan)(%cr)%Creset'\'' --abbrev-commit --date=relative'

  # docker-compose
  abbr --add --global dco 'docker compose'

  # lsd
  abbr --add --global ls 'lsd'
  abbr --add --global ll 'lsd --long'
  abbr --add --global la 'lsd --all --long'
  abbr --add --global tree 'lsd --tree'
end

# Set title of terminal
function fish_title
  basename (pwd)
end
