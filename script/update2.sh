#!/bin/bash
sudo apt update
sudo apt full-upgrade -y 
cargo install-update -a
sudo freshclam
sudo apt update
sudo apt full-upgrade -y
sudo apt dist-upgrade -y
sudo apt --fix-broken install
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
pipx upgrade-all
sudo dpkg --configure -a
#sudo locale-gen
#sudo update-locale
#sudo update-locale
#sudo update-initramfs -u -k all
#sudo update-grub
sudo parrut-upgrade
topgrade
