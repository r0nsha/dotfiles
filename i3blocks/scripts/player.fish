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
else if test "$player" = chrome; or test "$player" = brave; or test "$player" = chromium
    set player_icon "󰊯"
else
    set player_icon "󰎇"
end

if test "$(playerctl status)" = Playing
    set color "#ffffff"
else
    set color "#989898"
end

set -l song (playerctl metadata --format '{{trunc(artist, 20)}} - {{trunc(title, 30)}} {{duration(position)}}/{{duration(mpris:length)}}')

echo "<span color='$color'> $player_icon $song </span>"
