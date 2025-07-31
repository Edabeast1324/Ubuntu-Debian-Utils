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
sudo apt install iptables iptables-persistent -y
sleep 2
clear
echo "Fetching Latest Firewall Update"
sleep 2
clear
wget raw.githubusercontent.com/Edabeast1324/Ubuntu-Debian-Utils/main/bfw
chmod +x bfw
sudo mv bfw /usr/local/bin/
sleep 2
clear
echo "Installation Complete!"
