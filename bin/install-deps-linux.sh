info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

info "root access is needed to install dependencies"

install () {
  info "installing $1"
  sudo apt install $1
}

sudo apt update

for dep in zoxide fd-find exa ripgrep gh
do
  install $dep
done

unset install
