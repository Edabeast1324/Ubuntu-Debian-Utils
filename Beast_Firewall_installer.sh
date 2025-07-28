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
wget -O "bfw" "https://raw.githubusercontent.com/Edabeast1324/Ubuntu-Debian-Utils/main/Latest-Firewall.sh"
chmod +x bwf
sudo mv bwf /usr/local/bin/
sleep 2
clear
echo "Installation Complete!"
