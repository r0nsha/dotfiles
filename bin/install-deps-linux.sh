info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

DOWNLOADS=$HOME/downloads

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

install_deps () {
  info "root access is needed to install dependencies"

  install () {
    info "installing $1"
    sudo apt -y -qq install $1
  }

  sudo apt -y -qq update

  deps=(
    fish
    tmux
    zoxide
    fd-find
    exa
    ripgrep
    gh
    fzf
    bat
    gum
  )

  for dep in ${deps[@]}
  do
    install $dep
  done
}

install_nvim () {
  mkdir -p $DOWNLOADS
  curl -sL https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz | tar -xz -C $DOWNLOADS
  ln -sf $DOWNLOADS/nvim-linux64/bin/nvim $HOME/.local/bin/nvim
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
  export N_PREFIX=$HOME/.n
  export PATH=$N_PREFIX/bin:$PATH
  curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts
  npm install -g n
}

# install_smug () {
#   curl -sL https://github.com/ivaaaan/smug/releases/download/v0.3.3/smug_0.3.3_Linux_x86_64.tar.gz | tar -xz -C $DOWNLOADS
#   sudo mv $DOWNLOADS/smug /usr/local/bin
# }

install_deps
echo ""
install_wrapper nvim install_nvim
install_wrapper starship install_starship
install_wrapper rustup install_rustup
install_wrapper tmux install_tmux
install_wrapper n install_n
# install_wrapper smug install_smug
