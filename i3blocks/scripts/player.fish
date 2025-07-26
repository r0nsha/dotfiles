#!/usr/bin/env fish

# 󰈹󰓇

set -l player (playerctl metadata --format '{{playerName}}')

if test -z "$player"; or test "$player" = "No player found"
    exit
end

set -l url (playerctl metadata --format '{{xesam:url}}')
if string match -q "*youtube*" "$url"
    set player_icon "󰗃"
else if string match -q "*vimeo*" "$url"
    set player_icon "󰕷"
else if test "$player" = spotify
    set player_icon "󰓇"
else if test "$player" = vlc
    set player_icon "󰕼"
else if test "$player" = firefox
    set player_icon "󰈹"
else if test "$player" = chrome
    set player_icon "󰊯"
else
    set player_icon "󰎇"
end

set -l song (playerctl metadata --format '{{trunc(artist, 20)}} - {{trunc(title, 30)}} {{duration(position)}}/{{duration(mpris:length)}}')

echo " $player_icon $song "
