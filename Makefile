install:
	./bin/install.sh

update-dconf:
	dconf dump / >"$HOME/dotfiles/dconf/settings.ini"
	git add -u
	git commit -m "update dconf/settings.ini"
	git push

wallpapers:
	betterlockscreen -u ~/Pictures/Wallpapers
	feh --bg-scale ~/Pictures/Wallpapers/lanterns.jpg
	# feh --randomize --bg-scale --slideshow-delay 300 ~/Pictures/Wallpapers
