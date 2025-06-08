running "stowing dotfiles..."
cd $DOTFILES
stow .
if [ $? -eq 0 ]; then
	success 'stowed dotfiles, great success!'
else
	error 'stow failed!'
fi
