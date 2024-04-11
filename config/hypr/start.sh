#!/usr/bin/env bash

#Wallpaper
swww init &
swww img ~/.config/background &

#Network Manager
nm-applet --indicator &

waybar &

mako
