#!/bin/sh

#interface device
device=wlan0
# Get the signal strength (RSSI) using sudo iw
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
    firewall_status=$(sudo ufw status | grep "Status:" | awk '{print $2}')
    notify-send "📶 $ssid" "Quality: $quality%\nLocal IP: $local_ip\nFirewall: $firewall_status"
    ;;
  2)
    public_ip=$(curl -s ifconfig.me)
    mac_address=$(ip link show "$device" | awk '/link\/ether/ {print $2}')
    dns_servers=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}' | tr '\n' ' ')
    gateway_ip=$(ip route | grep default | awk '{print $3}')
    notify-send "🌐 Network Details" "Public IP: $public_ip\nMAC: $mac_address\nDNS: $dns_servers\nGateway: $gateway_ip"
    ;;
  6) st -e nvim "$0" ;;
esac

# Print the final icon only
echo "$icon "
