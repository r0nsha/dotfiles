#!/bin/bash

dconf dump / >"$HOME/dotfiles/dconf/settings.ini"
git add -u
git commit -m "update dconf/settings.ini"
git push
