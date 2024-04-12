#!/usr/bin/env bash

entries="Logout Suspend Reboot Shutdown"

selected=$(printf '%s\n' $entries | rofi -dmenu -p " Power Menu" | awk '{print tolower($1)}')

case $selected in
  logout)
    hyprctl dispatch exit;;
  suspend)
    exec systemctl suspend;;
  reboot)
    exec systemctl reboot;;
  shutdown)
    exec systemctl poweroff -i;;
esac
