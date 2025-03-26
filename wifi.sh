#!/bin/sh
#Variables
USER=efe
TERMINAL=st
EDITOR=nvim
WPACONFLOC=/etc/wpa_supplicant/wpa_supplicant.conf
NETWORKSTARTUPLOC=/home/$USER/.config/system/network-startup.sh
device=wlan0
signal=$(sudo iw dev "$device" link | grep -i signal | awk '{print $2}')

# Check if connected
if [ -z "$signal" ]; then
    icon="󰤮"  # No connection (Network Off)
else
    # Convert RSSI (-30 dBm best, -100 dBm worst) to percentage
    quality=$(( (signal + 100) * 100 / 70 ))

    # Choose WiFi strength icon
    if [ "$quality" -le 10 ]; then
        icon="󰤠"  # Weakest signal
    elif [ "$quality" -le 25 ]; then
        icon="󰤢"  # 2 bars
    elif [ "$quality" -le 50 ]; then
        icon="󰤥"  # 3 bars
    elif [ "$quality" -le 70 ]; then
        icon="󰖩"  # 4 bars
    else
        icon="󰖩"  # Strongest signal
    fi
fi
case $BLOCK_BUTTON in
    1)
        ssid=$(sudo iw dev "$device" link | grep SSID | awk '{print $2}')
        local_ip=$(ip a show "$device" | grep "inet " | awk '{print $2}')
        public_ip=$(curl -s ifconfig.me)
        mac_address=$(ip link show "$device" | awk '/link\/ether/ {print $2}')
        firewall_status=$(sudo ufw status | grep "Status:" | awk '{print $2}')
        dns_servers=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}' | tr '\n' ' ')
        notify-send "🌐 Network Details" "$ssid\nQuality:$quality%\nLocal-IP:$local_ip\nPublic IP:$public_ip\nMAC:$mac_address\nFirewall:$firewall_status\nDNS:$dns_servers"
        ;;
    2)
        "$TERMINAL" -e "$EDITOR" "$NETWORKSTARTUPLOC"
        ;;
    3)
        "$TERMINAL" -e sudo "$EDITOR" "$WPACONFLOC"
        ;;
    6)
        "$TERMINAL" -e "$EDITOR" "$0"
        ;;
esac

# Print the final icon only
echo "$icon "
