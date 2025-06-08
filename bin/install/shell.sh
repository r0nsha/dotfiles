running "setting default shell to fish..."
fish_bin=$(command -v fish)

if [ "$SHELL" != "$fish_bin" ]; then
	info "changing your default shell to fish"
	echo $fish_bin | sudo tee -a /etc/shells
	chsh -s $fish_bin
	success "your default shell is now fish. yay"
else
	info "your default shell is already fish, skipping"
fi
