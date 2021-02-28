if status --is-login
  # set PATH so it includes user's private bin if it exists
  if test -d ~/bin
    set -x PATH ~/bin $PATH
  end

  # chruby
  if test -d ~/.chruby
    set -x PATH ~/.chruby/bin $PATH
    set -x CHRUBY_ROOT ~/.chruby
    source ~/.chruby/share/chruby/chruby.fish
    chruby ruby
  end

  # yarn
  if test -d ~/.yarn
    set -x PATH ~/.yarn/bin $PATH
  end

  # cargo
  if test -d ~/.cargo
    set -x PATH ~/.cargo/bin $PATH
  end

  # fnm
  if command -v fnm &> /dev/null
    fnm env | source
  end
end

# Fix issue with QT applications and scaling
set -x QT_AUTO_SCREEN_SCALE_FACTOR 1

# Disable spring if used in Ruby project
set -x DISABLE_SPRING true

# Set editor
set -x EDITOR nvim

# Vim keybindings
fish_vi_key_bindings

# Starship prompt
starship init fish | source

# Define abbreviations
if status --is-interactive
  abbr --add --global vim 'nvim'
  abbr --global open 'open &> /dev/null'
end
