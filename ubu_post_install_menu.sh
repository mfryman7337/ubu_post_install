#!/bin/bash

# script by Michael Fryman based on work by github user waleedahmad
# original github source: https://gist.github.com/waleedahmad/e65afec97538a158eaeeffd79043eb2c
# but much was added now to configure Ubuntu with various settings, packages, etc.
# to improve things quite a bit
#
# This is intended for VM (virtual machine) installations of Ubuntu
# tested on Ubuntu 20.04 installed as guest VM on VMware Workstation

if [[ $EUID -ne 0 ]]; then

  echo "This script must be run as root"
  exit 1

else

  #Update and Upgrade
  echo '<<<<<<<<<<<< Updating and Upgrading >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  echo '<<<<<<<<<<<< currently commented out to save time >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  #apt-get update && apt-get upgrade -y

  # Install the dialog command
  echo '<<<<<<<<<<<< Install dialog package >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  apt-get install dialog

  cmd=(dialog --separate-output --checklist "Please select what you want:" 20 70 15)
  options=(1 "grub timeout 5 secs" off
    2 "set screen off to NEVER" off
    3 "set vim as cli editor" off
    4 "open-vm*, wget & more" off
    5 "Google Chrome browser" off
    6 "FOSS Chromium browser" off
    7 "MS Edge browser (coming soon)" off
    8 "MS VS Code" off
    9 "Git" off
    10 "Docker" off
    11 "Node.js" off
    12 "Open JRE 8" off
    13 "Open JRE 11" off
    14 "Open JRE 13" off
    15 "Open JRE 14" off
    20 "Postman" off
    21 "LAMP Stack" off
    22 "Build Essentials" off
    23 "Composer" off
    24 "Open JDK 8" off
    25 "Open JDK 11" off
    26 "Open JDK 13" off
    27 "Open JDK 14" off
    28 "Oracle's JAVA JDK 8" off
    99 "Last" off)
  choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

  clear
  for choice in $choices
  do
    case $choice in
        1)
          # set grub boot menu timeout to 5 seconds 
          if [[ ! $(grep -Fq "GRUB_RECORDFAIL_TIMEOUT=5" /etc/default/grub) ]]; then
            echo '<<<<<<<<<<<< grub boot menu timeout is already set to 5 seconds >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          else
            echo '<<<<<<<<<<<< set grub boot menu timeout to 5 seconds >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
            bash -c 'echo " " >> /etc/default/grub'
            bash -c 'echo "# Adjusted timeout for system which doesnt support recordfail" >> /etc/default/grub'
            bash -c 'echo "GRUB_RECORDFAIL_TIMEOUT=5" >> /etc/default/grub'
            update-grub
            echo '++++++++   You must reboot for the grub changes to take effect  ++++++++++++++'
          fi
          ;;
        2)
          #### Set power saving turn screen off setting to 0 seconds, i.e. NEVER
          #### since we don't need or want the screen to turn off on our virtual machines typically
          echo '<<<<<<<<<<<< Set power saving turn screen off setting to 0 seconds, i.e. NEVER >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          #### use either of these 2 following methods, either works
          #dconf write /org/gnome/desktop/session/idle-delay "uint32 0"
          gsettings set org.gnome.desktop.session idle-delay 0
          ;;
        3)
          # setup vi command line editing for all users as default
          if [[ $(grep -Fq "set -o vi" /etc/bash.bashrc) ]]; then
            echo '<<<<<<<<<<<< vi is already set as bash command line editor >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          else
            echo '<<<<<<<<<<<< setting vi to be command line editor >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
            bash -c 'echo " " >> /etc/bash.bashrc'
            bash -c 'echo "set -o vi" >> /etc/bash.bashrc'
          fi
          ;;
        4)
          # Install open-vm*, wget, curl, other utils 
          echo '<<<<<<<<<<<< Installing open-vm*, wget, curl, other utils >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          apt install -y open-vm-tools open-vm-tools-desktop wget curl vim p7zip-full xclip
          ;;
        5)
          # Install Google Chrome browser
          echo '<<<<<<<<<<<< Installing Google Chrome browser >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
          TempFile1=/etc/apt/sources.list.d/google-chrome.list
          if [[ -f "$TempFile1" ]]; then
            echo "The file  $TempFile1  exists already"
          else
            sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> $TempFile1'
          fi
          apt update
          apt install -y google-chrome-stable
          ;;
        6)
          # Install FOSS Chromium browser
          if [[ $(snap list | grep chromium) ]]; then
            echo '<<<<<<<<<<<< FOSS Chromium browser is already installed >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          else
            echo '<<<<<<<<<<<< Installing FOSS Chromium browser >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
            #apt install -y chromium-browser chromium-codecs-ffmpeg-extra chromium-codecs-ffmpeg
            snap install chromium chromium-ffmpeg
	  fi
          ;;
        7)
          # Install MS Edge browser
          echo '<<<<<<<<<<<< Installing MS Edge browser >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          echo '* * * not available yet * * *'
          #apt install -y ms-edge-browser
          ;;
        8)
          # Install MS VS Code
          if [[ $(snap list | grep vscode) ]]; then
            echo '<<<<<<<<<<<< MS VS Code is already installed >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          else
            echo '<<<<<<<<<<<< Installing MS VS Code >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
            #apt install -y vscode
            snap install --classic code
	  fi
          ;;
        9)
          # Install git and hub
          echo '<<<<<<<<<<<< Installing git and hub >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          echo '<<<<<<<<<<<< Please congiure git later... >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          apt install -y git hub
          ;;
        10)
          # Install docker
          echo '<<<<<<<<<<<< Installing docker >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          echo '<<<<<< First some docker pre-reqs.... >>>>>>>>>>>>>>>>>>>>>'
          apt install apt-transport-https ca-certificates curl software-properties-common
          echo '<<<<<< Next add the docker gpg key.... >>>>>>>>>>>>>>>>>>>>>'
          curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
          echo '<<<<<< Next add docker repo to our apt repo list.... >>>>>>>>>>>>>>>>>>>>>'
          add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
          echo '<<<<<< Update our apt data again.... >>>>>>>>>>>>>>>>>>>>>'
          apt update
          echo '<<<<<< Now we finally install docker >>>>>>>>>>>>>>>>>>>>>'
          apt-get install docker-ce
          echo '<<<<<< Enable docker to run at startup >>>>>>>>>>>>>>>>>>>>>'
          systemctl enable docker
          echo '<<<<<< Start the docker service now >>>>>>>>>>>>>>>>>>>>>'
          systemctl start docker
          ;;
        11)
          # Install Nodejs
          echo '<<<<<<<<<<<< Installing Nodejs >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          # next line only for downloading certain version from source
          #curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
          apt install -y nodejs
          ;;
        12)
          # Install Open JAVA JRE 8
          echo '<<<<<<<<<<<< Installing Open JAVA JRE 8 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          apt install -y openjdk-8-jre
          sudo update-alternatives --config java
          ;;
        13)
          # Install Open JAVA JRE 11
          echo '<<<<<<<<<<<< Installing Open JAVA JRE 11 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          apt install -y openjdk-11-jre
          sudo update-alternatives --config java
          ;;
        14)
          # Install Open JAVA JRE 13
          echo '<<<<<<<<<<<< Installing Open JAVA JRE 13 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          apt install -y openjdk-13-jre
          sudo update-alternatives --config java
          ;;
        15)
          # Install Open JAVA JRE 14
          echo '<<<<<<<<<<<< Installing Open JAVA JRE 14 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          apt install -y openjdk-14-jre
          sudo update-alternatives --config java
          ;;
        20)
          # Install postman
          echo '<<<<<<<<<<<< Installing postman >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          apt install -y postman
          ;;
        21)
          #Install LAMP stack
          echo "Installing Apache"
          apt install -y apache2
          echo "Installing Mysql Server"
          apt install -y mysql-server
          echo "Installing PHP"
          apt install -y php libapache2-mod-php php-mcrypt php-mysql
          echo "Installing Phpmyadmin"
          apt install -y phpmyadmin
          echo "Cofiguring apache to run Phpmyadmin"
          echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
          echo "Restarting Apache Server"
          service apache2 restart
          ;;
        22)
          #Install Build Essentials
          echo "Installing Build Essentials"
          apt install -y build-essential
          ;;
        23)
          #Composer
          echo "Installing Composer"
          EXPECTED_SIGNATURE=$(wget https://composer.github.io/installer.sig -O - -q)
          php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
          ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")
          if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]
          then
          php composer-setup.php --quiet --install-dir=/bin --filename=composer
          RESULT=$?
          rm composer-setup.php
          else
          >&2 echo 'ERROR: Invalid installer signature'
          rm composer-setup.php
          fi
          ;;
        24)
          # Install Open JAVA JRE 8
          echo '<<<<<<<<<<<< Installing Open JAVA JRE 8 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          apt install -y openjdk-8-jre
          sudo update-alternatives --config java
          ;;
        25)
          # Install Open JAVA JRE 11
          echo '<<<<<<<<<<<< Installing Open JAVA JRE 11 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          apt install -y openjdk-11-jre
          sudo update-alternatives --config java
          ;;
        26)
          # Install Open JAVA JRE 13
          echo '<<<<<<<<<<<< Installing Open JAVA JRE 13 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          apt install -y openjdk-13-jre
          sudo update-alternatives --config java
          ;;
        27)
          # Install Open JAVA JRE 14
          echo '<<<<<<<<<<<< Installing Open JAVA JRE 14 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          apt install -y openjdk-14-jre
          sudo update-alternatives --config java
          ;;
        28)
          # Install Oracle JAVA JDK 8
          echo '<<<<<<<<<<<< Installing Oracles JAVA JDK 8 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          apt install python-software-common -y
          add-apt-repository ppa:webupd8team/java -y
          apt update
          apt install oracle-java8-installer -y
          ;;
        99)
          # Last
          #echo "xxxx"
          #apt install -y xxxx
          ;;
    esac
  done
fi

# clean up our apt database and packages, remove anything no longer needed
echo '<<<<<<<<<<<< apt autoremove to clean up >>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
apt autoremove

exit 0

############# end of file ######################

