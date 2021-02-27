if status --is-login
  # set PATH so it includes user's private bin if it exists
  if test -d ~/bin
    set -x PATH ~/bin $PATH
  end

  # support chruby
  if test -d ~/.chruby
    set -x PATH ~/.chruby/bin $PATH
    set -x CHRUBY_ROOT ~/.chruby
    source ~/.chruby/share/chruby/chruby.fish
  end

  # support yarn
  if test -d ~/.yarn
    set -x PATH ~/.yarn/bin $PATH
  end

  # support cargo
  if test -d ~/.cargo
    set -x PATH ~/.cargo/bin $PATH
  end
end

# Vim keybindings
fish_vi_key_bindings

# Starship prompt
starship init fish | source
