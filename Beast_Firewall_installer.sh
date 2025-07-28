#!/bin/bash
clear
echo "Updating System"
sleep 2
clear
sudo apt update && sudo apt upgrade -y
CheckFail()
sleep 2
clear
echo "Installing Dependencies"
sleep 2
clear
sudo apt install iptables ip6tables iptables-persistent -y
CheckFail()
sleep 2
clear
echo "Fetching Latest Firewall Update"
sleep 2
clear
wget -O "Firewall.sh" "raw.githubusercontent.com/Edabeast1324/Ubuntu-Debian-Utils/refs/heads/main/Firewall-Releases/Latest.sh"
CheckFail()

function CheckFail() {
status=$?
if [ $status -ne 0 ]; then
    exit 1
fi
