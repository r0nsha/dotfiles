running "creating env file..."
env_file="$HOME/.env.fish"
if test -f "$env_file"; then
	info "$env_file file already exists, skipping"
else
	echo "set -Ux DOTFILES $DOTFILES" >$env_file
	success "created $env_file"
fi
