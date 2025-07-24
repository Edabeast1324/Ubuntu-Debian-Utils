#!/bin/bash
clear
echo "Welcome to tha Kasm autoinstaller!"
echo "1) Install for AMD64"
echo "2) Install for ARM64"
read -p "Choose an option: " choice

if [[ "$choice" == 1 ]]; then
clear
echo "Updating system"
sleep 2
clear
sudo apt update && sudo apt upgrade -y
clear
echo "System up to date"
sleep 2
clear
echo "Fetching files"
sleep 2
clear
wget https://kasm-static-content.s3.amazonaws.com/kasm_release_1.17.0.7f020d.tar.gz
clear
echo "Files Fetched"
sleep 2
clear
echo "Running install script"
sleep 2
clear
tar -xf kasm_release_1.14.0.01f0e.tar.gz
cd kasm_release
sudo bash install.sh
clear
echo "Successfully Installed"
echo "Go to http://<your-ip-address> to access, or go to http://localhost on the same device"

elif [[ "$choice" == 2 ]]; then
