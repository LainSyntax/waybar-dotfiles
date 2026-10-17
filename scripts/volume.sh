#!/bin/bash

notify_vol() {
    vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')
    mute=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED)

    if [ "$mute" -eq 1 ]; then
        notify-send -a "Volume" -u low -h string:x-dunst-stack-tag:volume -t 1500 "Sound on"
    else
        notify-send -a "Volume" -u low -h string:x-dunst-stack-tag:volume -h int:value:"$vol" -t 1500 "Volume: ${vol}%"
    fi
}

notify_mic() {
    mute=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -c MUTED)
    if [ "$mute" -eq 1 ]; then
        notify-send -a "Microphone" -u low -h string:x-dunst-stack-tag:mic -t 1500 "Mic off"
    else
        notify-send -a "Microphone" -u low -h string:x-dunst-stack-tag:mic -t 1500 "Mic on"
    fi
}

case $1 in
    up)
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
        notify_vol
        ;;
    down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        notify_vol
        ;;
    toggle)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        notify_vol
        ;;
    mic-toggle)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        notify_mic
        ;;
esac
