#!/bin/bash

# State tracking variables
critical_notified_file="/tmp/battery_critical_notified"
low_notified_file="/tmp/battery_low_notified"
high_notified_file="/tmp/battery_high_notified"

urgent_sound_file="/home/$USER/audio/bell-meme.wav"
low_sound_file="/home/$USER/audio/soft-alert.wav"
high_sound_file="/home/$USER/audio/ui-pop.wav"

# Function to send notification with sound
send_notification() {
    local urgency=$1
    local title=$2
    local message=$3
    local sound_file=$4

    notify-send -u "$urgency" "$title" "$message"
    [ -f "$sound_file" ] && aplay "$sound_file" &
}

get_charging_emoji() {
    local capacity=$1
    if [ "$capacity" -le 10 ]; then echo "󰢜"; elif [ "$capacity" -le 20 ]; then echo "󰂆"; elif [ "$capacity" -le 30 ]; then echo "󰂇"; elif [ "$capacity" -le 40 ]; then echo "󰂈"; elif [ "$capacity" -le 50 ]; then echo "󰢝"; elif [ "$capacity" -le 60 ]; then echo "󰂉"; elif [ "$capacity" -le 70 ]; then echo "󰢞"; elif [ "$capacity" -le 80 ]; then echo "󰂊"; elif [ "$capacity" -le 90 ]; then echo "󱊦"; else echo "󱊦"; fi
}

get_discharging_emoji() {
    local capacity=$1
    if [ "$capacity" -le 10 ]; then echo "󰁺"; elif [ "$capacity" -le 20 ]; then echo "󰁻"; elif [ "$capacity" -le 30 ]; then echo "󰁼"; elif [ "$capacity" -le 40 ]; then echo "󰁽"; elif [ "$capacity" -le 50 ]; then echo "󰁾"; elif [ "$capacity" -le 60 ]; then echo "󰁿"; elif [ "$capacity" -le 70 ]; then echo "󰂀"; elif [ "$capacity" -le 80 ]; then echo "󰂁"; elif [ "$capacity" -le 90 ]; then echo "󰂂"; else echo "󰁹"; fi
}

get_color() {
    local capacity=$1
    if [ "$capacity" -le 10 ]; then echo "^c#ee0909^"; elif [ "$capacity" -le 20 ]; then echo "^c#ee2809^"; elif [ "$capacity" -le 30 ]; then echo "^c#ee5809^"; elif [ "$capacity" -le 40 ]; then echo "^c#ee9809^"; elif [ "$capacity" -le 50 ]; then echo "^c#e3ee09^"; elif [ "$capacity" -le 60 ]; then echo "^c#b1ee09^"; elif [ "$capacity" -le 70 ]; then echo "^c#78ee09^"; elif [ "$capacity" -le 80 ]; then echo "^c#28ee09^"; elif [ "$capacity" -le 90 ]; then echo "^c#09eec4^"; else echo "^c#0942ee^"; fi
}

# Loop through all attached batteries
for battery in /sys/class/power_supply/BAT?*; do
    if [ -r "$battery/capacity" ] && [ -r "$battery/status" ]; then
        capacity=$(cat "$battery/capacity")
        status=$(cat "$battery/status")

        emoji=""
        color=$(get_color "$capacity")

        case "$status" in
            Charging)
                emoji=$(get_charging_emoji "$capacity")
                rm -f "$critical_notified_file" "$low_notified_file"

                if [ "$capacity" -ge 80 ] && [ ! -f "$high_notified_file" ]; then
                    send_notification normal "Battery Full Enough" "Battery at ${capacity}%, consider unplugging!" "$high_sound_file"
                    touch "$high_notified_file"
                fi
                ;;
            Discharging)
                emoji=$(get_discharging_emoji "$capacity")

                if [ "$capacity" -le 10 ] && [ ! -f "$critical_notified_file" ]; then
                    send_notification critical "Battery Critical" "Battery at ${capacity}%! Plug in now!" "$urgent_sound_file"
                    touch "$critical_notified_file"
                elif [ "$capacity" -le 20 ] && [ ! -f "$low_notified_file" ]; then
                    send_notification normal "Battery Low" "Battery at ${capacity}%!" "$low_sound_file"
                    touch "$low_notified_file"
                fi

                rm -f "$high_notified_file" # Reset high notification when discharging
                ;;
            Not\ charging)
                emoji="󰂃" # Not charging
                ;;
            Unknown)
                emoji="󱠴" # Unknown state
                ;;
        esac

        echo -e "${color}${emoji}^d^ ${capacity}%"
    else
        echo "󱟩"
    fi
done

case $BLOCK_BUTTON in
    1) notify-send "$(acpi -b | sed -E 's/^Battery [0-9]+: //; s/, //; s/([0-9]+)%$/\n\1%/')" ;;
    6) st -e nvim "$0" ;;
esac
