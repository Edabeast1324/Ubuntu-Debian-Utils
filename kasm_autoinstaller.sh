#!/bin/bash
clear

echo "Welcome to the Kasm autoinstaller!"
echo "1) Install for AMD64"
echo "2) Install for ARM64"
echo "3) Uninstall kasm"
read -p "Choose an option: " choice

if [[ "$choice" == "1" ]]; then
    clear
    echo "Updating system"
    sleep 2
    sudo apt update && sudo apt upgrade -y
    clear
    echo "System up to date"
    sleep 2

    echo "Fetching files"
    sleep 2
    wget https://kasm-static-content.s3.amazonaws.com/kasm_release_1.17.0.7f020d.tar.gz
    clear
    echo "Files fetched"
    sleep 2

    echo "Running install script"
    sleep 2
    tar -xf kasm_release_1.17.0.7f020d.tar.gz
    cd kasm_release
    sudo bash install.sh

    echo "Successfully Installed"
    echo "Go to http://<your-ip-address> to access, or http://localhost on this device"

elif [[ "$choice" == "2" ]]; then
    clear
    echo "Updating system"
    sleep 2
    sudo apt update && sudo apt upgrade -y
    clear
    echo "System up to date"
    sleep 2

    echo "Fetching files"
    sleep 2
    wget https://kasm-static-content.s3.amazonaws.com/kasm_release_1.17.0.7f020d.tar.gz
    clear
    echo "Files fetched"
    sleep 2

    echo "Running install script"
    sleep 2
    tar -xf kasm_release_1.17.0.7f020d.tar.gz
    cd kasm_release
    sudo bash install.sh
    echo "If the script ended with a subprocess error, run this script again. That always happens to me on ARM."
    echo "Install script finished"
    echo "Go to http://<your-ip-address> to access, or http://localhost on this device"

elif [[ "$choice" == "3" ]]; then
    sudo /opt/kasm/current/bin/stop
    sudo docker rm -f $(sudo docker container ls -qa --filter="label=kasm.kasmid")
    export KASM_UID=$(id kasm -u)
    export KASM_GID=$(id kasm -g)
    sudo -E docker compose -f /opt/kasm/current/docker/docker-compose.yaml rm
    sudo docker network rm kasm_default_network
    plugin_name=$(sudo docker network inspect kasm_sidecar_network --format '{{.Driver}}')
    sudo docker network rm kasm_sidecar_network
    sudo docker plugin disable $plugin_name
    sudo docker plugin rm $plugin_name
    sudo rm -rf /var/log/kasm-sidecar
    sudo rm -rf /var/run/kasm-sidecar
    sudo docker volume rm kasm_db_1.17.0
    sudo docker rmi redis:5-alpine
    sudo docker rmi postgres:14-alpine
    sudo docker rmi kasmweb/nginx:latest
    sudo docker rmi kasmweb/share:1.17.0
    sudo docker rmi kasmweb/agent:1.17.0
    sudo docker rmi kasmweb/manager:1.17.0
    sudo docker rmi kasmweb/api:1.17.0
    sudo docker rmi $(sudo docker images --filter "label=com.kasmweb.image=true" -q)
    sudo rm -rf /opt/kasm/
    sudo deluser kasm_db
    sudo deluser kasm
else
    echo "Invalid choice. Exiting"
    exit 1

fi
