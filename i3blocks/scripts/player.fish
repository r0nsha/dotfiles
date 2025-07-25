#!/usr/bin/env fish

# 󰈹󰓇
playerctl metadata --follow --format ' 󰎇 {{ artist }} - {{ title }} - {{duration(position)}} '
