#!/usr/bin/env bash

#Wallpaper
swww init &
swww img ~/.config/swww/bg.jpg &

#Network Manager
nm-applet --indicator &

waybar &

mako
