info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

DOWNLOADS=$HOME/downloads

install_deps () {
  info "root access is needed to install dependencies"

  install () {
    info "installing $1"
    sudo apt install $1
  }

  sudo apt update

  while read dep
  do
    install $dep
  done <$DOTFILES/bin/deps

  unset install
}

install_nvim () {
  if command -v nvim &> /dev/null
  then
    info "downloading neovim"
    mkdir -p $DOWNLOADS
    curl -sL https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz | tar -xz -C $DOWNLOADS
    ln -sf $DOWNLOADS/nvim-linux64/bin/nvim $HOME/.local/bin/nvim
    success "installed neovim"
  else
    success "neovim is already installed, skipping"
  fi
}

install_deps
install_nvim
