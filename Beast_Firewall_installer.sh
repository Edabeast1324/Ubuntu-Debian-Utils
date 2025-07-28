#!/bin/bash
clear
echo "Updating System"
sleep 2
clear
sudo apt update && sudo apt upgrade -y
sleep 2
clear
echo "Installing Dependencies"
sleep 2
clear
sudo apt install iptables ip6tables iptables-persistent -y
sleep 2
clear
echo "Fetching Latest Firewall Update"
sleep 2
clear
wget -O "Firewall.sh" "raw.githubusercontent.com/Edabeast1324/Ubuntu-Debian-Utils/refs/heads/main/Firewall-Releases/Latest.sh"
status=$?
if [ $status -ne 0 ]; then
    case $status in
        1) echo "❌ Generic error occurred.";;
        4) echo "❌ Network failure. Check your internet."; exit 4;;
        8) echo "❌ Server error (e.g. 404 Not Found).";;
        *) echo "❌ Unknown error (code $status).";;
    esac
    exit $status
fi
