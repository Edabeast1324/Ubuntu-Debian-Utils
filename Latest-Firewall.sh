#!/bin/bash

case "$1" in
  allow)
    case "$2" in
      all)
        echo "Allowing All Ports"
        
        sudo iptables -P INPUT ACCEPT
        sudo iptables -P FORWARD ACCEPT
        sudo iptables -P OUTPUT ACCEPT

        echo "All Ports Allowed"
        ;;
      *)
        echo "Unknown 'allow' argument: $2"
        ;;
    esac
    ;;
  block)
    case "$2" in
      all)
        echo "Blocking All Ports"

        sudo iptables -P INPUT DROP
        sudo iptables -P FORWARD DROP
        sudo iptables -P OUTPUT DROP

        echo "All Ports Blocked"
esac
