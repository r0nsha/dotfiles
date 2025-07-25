#!/usr/bin/env bash

# this prints a beautifully formatted list. bash was a mistake
nmcli -t d wifi rescan
LIST=$(nmcli --fields SSID,SECURITY,BARS device wifi list | sed '/^--/d' | sed 1d | sed -E "s/WPA*.?\S/~~/g" | sed "s/~~ ~~/~~/g;s/802\.1X//g;s/--/~~/g;s/  *~/~/g;s/~  */~/g;s/_/ /g" | column -t -s '~')

# get current connection status
CONSTATE=$(nmcli -fields WIFI g)
if [[ "$CONSTATE" =~ "disabled" ]]; then
	TOGGLE="Enable WiFi 󰖩"
	CHENTRY=$(echo -e "$TOGGLE" | uniq -u | rofi -dmenu -selected-row 1 -p "WiFi")
	if [[ "$CHENTRY" == "Enable WiFi"* ]]; then
		nmcli radio wifi on
		notify-send "WiFi enabled"
	fi
	exit
fi

TOGGLE="Disable WiFi 󰖪"

CHENTRY=$(echo -e "$TOGGLE\n$LIST" | uniq -u | rofi -dmenu -selected-row 1 -p "WiFi")

if [ "$CHENTRY" = "" ]; then
	exit
elif [[ "$CHENTRY" == "Disable WiFi"* ]]; then
	nmcli radio wifi off
	notify-send "WiFi disabled"
else
	CHNAME=$(echo "$CHENTRY" | awk '{print $1}')
	# store selected SSID
	CHSSID=$(echo "$CHENTRY" | sed 's/\s\{2,\}/\|/g' | awk -F "|" '{print $1}')

	# get list of known connections
	KNOWNCON=$(nmcli connection show)

	# If the connection is already in use, then this will still be able to get the SSID
	if [ "$CHSSID" = "*" ]; then
		CHSSID=$(echo "$CHENTRY" | sed 's/\s\{2,\}/\|/g' | awk -F "|" '{print $3}')
	fi

	# Parses the list of preconfigured connections to see if it already contains the chosen SSID. This speeds up the connection process
	if [[ $(echo "$KNOWNCON" | grep "$CHSSID") = "$CHSSID" ]]; then
		nmcli con up "$CHSSID"
	else
		if [[ "$CHENTRY" =~ "" ]]; then
			WIFIPASS=$(echo " Press Enter if network is saved" | rofi -dmenu -password -p "$CHNAME Password" -lines 1)
		fi
		if nmcli dev wifi con "$CHSSID" password "$WIFIPASS"; then
			notify-send "Connected to $CHNAME"
		else
			notify-send "Connection to $CHNAME failed"
		fi
	fi
fi
