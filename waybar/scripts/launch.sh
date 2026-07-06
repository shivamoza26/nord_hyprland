#!/bin/bash
hyprctl reload
killall -9 waybar
waybar &
