install:
	./bin/install.sh

update-dconf:
	dconf dump / >"$HOME/dotfiles/dconf/settings.ini"
	git add -u
	git commit -m "update dconf/settings.ini"
	git push

backgrounds:
	betterlockscreen -u ~/pictures/backgrounds
	feh --randomize --bg-scale --slideshow-delay 300 ~/pictures/backgrounds
