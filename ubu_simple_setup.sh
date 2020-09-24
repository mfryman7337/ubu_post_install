#!/bin/bash

###  Simple Ubuntu post installation setup script
###  Michael Fryman

if [[ $EUID -ne 0 ]]; then

  echo "This script must be run as root by sudo bash -c"
  exit 1

else
  # toggle on Canonical partner repository
  echo '<<<<<<<<<<<< toggle on Canonical partner repository >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  sed -i 's+\# deb http://archive.canonical.com/ubuntu focal partner+deb http://archive.canonical.com/ubuntu focal partner+g' /etc/apt/sources.list

  # setup vi command line editing for all users as default
  bash -c 'echo "set -o vi" >> /etc/bash.bashrc'

  #Update and Upgrade
  echo '<<<<<<<<<<<< Updating and Upgrading >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  apt-get update && apt-get upgrade -y

  # Install open-vm*, wget, curl, other utils 
  echo '<<<<<<<<<<<< Installing open-vm*, wget, curl, other utils >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  apt install -y open-vm* wget curl vim p7zip-full xclip dialog

  # set grub boot menu timeout to 5 seconds 
  echo '<<<<<<<<<<<< set grub boot menu timeout to 5 seconds >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  bash -c 'echo " " >> /etc/default/grub'
  bash -c 'echo "# Adjusted timeout for system which doesn't support recordfail" >> /etc/default/grub'
  bash -c 'echo "GRUB_RECORDFAIL_TIMEOUT=5" >> /etc/default/grub'
  update-grub
  echo '++++++++   You must reboot for the grub changes to take effect  ++++++++++++++"

  #### Set power saving turn screen off setting to 0 seconds, i.e. NEVER
  #### since we don't need or want the screen to turn off on our virtual machines typically
  echo '<<<<<<<<<<<< Set power saving turn screen off setting to 0 seconds, i.e. NEVER >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  #### use either of these 2 following methods, either works
    # dconf write /org/gnome/desktop/session/idle-delay "uint32 0"
    gsettings set org.gnome.desktop.session idle-delay 0

  # Install MS VS Code
  echo '<<<<<<<<<<<< Installing MS VS Code >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  #apt install -y vscode
  snap install --classic code

  # Install Google Chrome browser
  echo '<<<<<<<<<<<< Installing Google Chrome browser >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  TempFile1=/etc/apt/sources.list.d/google-chrome.list
  if [[ -f "$TempFile1" ]]; then
    echo "The file  $TempFile1  exists already"
  else
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> $TempFile1
  fi
  apt update
  apt install -y google-chrome-stable

  # Install FOSS Chromium browser
  echo '<<<<<<<<<<<< Installing FOSS Chromium browser >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  #apt install -y chromium-browser chromium-codecs-ffmpeg-extra chromium-codecs-ffmpeg
  snap install chromium chromium-ffmpeg

  # Install MS Edge browser
  #echo '<<<<<<<<<<<< Installing MS Edge browser >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  #echo '* * * not available yet * * *'
  #apt install -y ms-edge-browser

  #Install Nodejs
  #echo '<<<<<<<<<<<< Installing Nodejs >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  #curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
  #apt install -y nodejs

  #Install git
  #echo '<<<<<<<<<<<< Installing Git, please congiure git later... >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  #apt install -y git 

  # Install postman
  #echo '<<<<<<<<<<<< Installing postman >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  #apt install postman -y 

fi
