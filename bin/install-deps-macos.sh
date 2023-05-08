info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

DOWNLOADS=$HOME/Downloads

install_wrapper () {
  if ! command -v $1 &> /dev/null
  then
    info "installing $1"
    $2
    success "installed $1"
  else
    success "$1 is already installed, skipping"
  fi
}

install_brew () {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew update --force
}

install_deps () {
  info "root access is needed to install dependencies"

  install () {
    info "installing $1"
    brew install -q $1
  }

  deps=(
    fish
    tmux
    zoxide
    fd
    exa
    ripgrep
    gh
  )

  for dep in ${deps[@]}
  do
    install $dep
  done
}


install_nvim () {
  mkdir -p $DOWNLOADS
  curl -sL https://github.com/neovim/neovim/releases/download/stable/nvim-macos.tar.gz --output $DOWNLOADS/nvim-macos.tar.gz
  cd $DOWNLOADS
  xattr -c ./nvim-macos.tar.gz
  tar xzf nvim-macos.tar.gz
  cd $HOME
  ln -sf $DOWNLOADS/nvim-macos/bin/nvim $HOME/.local/bin/nvim
}

install_starship () {
  curl -sS https://starship.rs/install.sh | sh
}

install_rustup () {
  curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable
}

install_tmux () {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  cargo install tmux-sessionizer
}

install_n () {
  curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts
  npm install -g n
}

install_wrapper brew install_brew
install_deps
echo ""
install_wrapper nvim install_nvim
install_wrapper starship install_starship
install_wrapper rustup install_rustup
install_wrapper tmux install_tmux
install_wrapper n install_n
