#!/bin/bash
clear
echo "Welcome to Apache Guacamole Autoinstaller"
echo "1) Install for AMD64"
echo "2) Install for ARM64"
read -p "Choose an option: " choice

if [[ "$choice" == 1 ]]; then
    echo "Updating System"
    sleep 2
    clear
    (sudo apt update && sudo apt upgrade -y)
    clear
    echo "System Up to date"
    sleep 2
    clear
    echo "Installing Docker"
    sleep 2
    clear
    (curl -fsSL https://get.docker.com -o get-docker.sh)
    (sudo sh get-docker.sh)
    (sudo usermod -aG docker $USER)
    clear
    echo "Docker is installed"
    sleep 2
    clear
    echo "Installing Docker-Compose"
    sleep 2
    clear
    (sudo apt install -y libffi-dev libssl-dev python3-dev python3 python3-pip)
    (sudo apt install -y python3 docker-compose)
    clear
    echo "Docker-Compose is installed"
    sleep 2
    clear
    echo "Creating Docker Compose File"
    sleep 2
    clear
    (mkdir -p ~/guacamole && cd ~/guacamole)

    cat << EOF > ~/guacamole/docker-compose.yml
version: '3'
services:
  guacd:
    image: guacamole/guacd
    restart: always

  guacamole:
    image: oznu/guacamole
    restart: always
    ports:
      - "8080:8080"
    environment:
      - MYSQL_HOST=mysql
      - MYSQL_PORT=3306
      - MYSQL_DATABASE=guacamole_db
      - MYSQL_USER=guacamole_user
      - MYSQL_PASSWORD=guac_pass
      - GUACAMOLE_HOME=/config
    depends_on:
      - mysql
    volumes:
      - ./guac-home:/config

  mysql:
    image: mysql:5.7
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=root_pass
      - MYSQL_DATABASE=guacamole_db
      - MYSQL_USER=guacamole_user
      - MYSQL_PASSWORD=guac_pass
    volumes:
      - ./mysql:/var/lib/mysql
EOF

    echo "File created"
    sleep 2
    clear
    echo "Creating containers and pulling files"
    (cd ~/guacamole && docker-compose up -d)
    clear
    echo "Fully installed!"
    echo "Go to: <your device's ip>:8080 to acess"
    echo "Or on this device, go to http://localhost:8080"

elif [[ "$choice" == 2 ]]; then
    clear
    echo "Updating System"
    sleep 2
    clear
    (sudo apt update && sudo apt upgrade -y)
    clear
    echo "System up to date"
    sleep 2
    clear
    echo "Installing Docker"
    sleep 2
    clear
    (curl -fsSL https://get.docker.com -o get-docker.sh)
    (sudo sh get-docker.sh)
    (sudo usermod -aG docker $USER)
    clear
    echo "Docker is installed"
    sleep 2
    clear
    echo "Installing Docker-Compose"
    sleep 2
    clear
    (sudo apt install -y libffi-dev libssl-dev python3-dev python3 python3-pip)
    (sudo apt install -y python3 docker-compose)
    clear
    echo "Docker-Compose is installed"
    sleep 2
    clear
    echo "Creating Docker Compose File"
    sleep 2
    clear
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
    sleep 2
    clear
    echo "Creating containers and pulling files"
    sleep 2
    clear
    (cd ~/guacamole && docker-compose up -d)
    clear
    echo "Fully installed!"
    echo "Go to: <your device's ip>:8080 to acess"

fi
