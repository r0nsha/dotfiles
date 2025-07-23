install:
	./bin/install.sh

update-dconf:
	dconf dump / >"$HOME/dotfiles/dconf/settings.ini"
	git add -u
	git commit -m "update dconf/settings.ini"
	git push

wallpapers:
	betterlockscreen -u ~/Pictures/Wallpapers
	feh --randomize --bg-scale --slideshow-delay 301 ~/Pictures/Wallpapers
