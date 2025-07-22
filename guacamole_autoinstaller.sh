#!/bin/bash
clear
echo "Welcome to Apache Guacamole Autoinstaller"
echo "1) Install for AMD64"
echo "2) Install for ARM64"
read -p "Choose an option: " choice

if [[ "$choice" == 1 ]]; then
    echo "Updating System"
    (sudo apt update && sudo apt upgrade -y)

elif [[ "$choice" == 2 ]]; then
    echo "Updating System"
    (sudo apt update && sudo apt upgrade -y)
    echo "System up to date"
    echo "Installing Docker"
    (curl -fsSL https://get.docker.com -o get-docker.sh)
    (sudo sh get-docker.sh)
    (sudo usermod -aG docker $USER)
    echo "Docker is installed"

    echo "Installing Docker-Compose"
    (sudo apt install -y libffi-dev libssl-dev python3-dev python3 python3-pip)
    (sudo apt install -y python3 docker-compose)
    echo "Docker-Compose is installed"

    echo "Creating Docker Compose File"
    (mkdir -p ~/guacamole && cd ~/guacamole)

    cat << EOF > ~/guacamole/docker-compose.yml
version: '3.7'
services:
  mysql:
    image: mysql:8.0
    container_name: mysql
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: root_pass
      MYSQL_DATABASE: guacamole_db
      MYSQL_USER: guacamole_user
      MYSQL_PASSWORD: guac_pass
    volumes:
      - ./mysql:/var/lib/mysql

  guacd:
    image: lscr.io/linuxserver/guacd:latest
    container_name: guacd
    restart: unless-stopped

  guacamole:
    image: flcontainers/guacamole:latest
    container_name: guacamole
    restart: unless-stopped
    depends_on:
      - guacd
      - mysql
    environment:
      MYSQL_HOST: mysql
      MYSQL_DATABASE: guacamole_db
      MYSQL_USER: guacamole_user
      MYSQL_PASSWORD: guac_pass
    ports:
      - "8080:8080"
    volumes:
      - ./guac-config:/config
EOF

    echo "File created"
    echo "Creating containers and pulling files"
    (cd ~/guacamole && docker-compose up -d)
    echo "Fully installed!"
fi
