#!/bin/bash
# Pop!_OS 20.04 Setup

# Configure passwordless SSH from this host
# echo -n "Configure passwordless SSH from this host to a target? [y/n]: "
# read -n 1 INPUT
# echo ""
# if [[ $INPUT == "y" ]]; then
#     echo -n "Enter Target IP: "
#     read ADDRESS
#     echo ""
#     echo "Press ENTER for all of the following..."
#     echo "(Overwrite if necessary)"
#     echo ""
#     ssh-keygen -t rsa
#     ssh <USERNAME>@$ADDRESS mkdir -p .ssh
#     cat /home/<USERNAME>/.ssh/id_rsa.pub | ssh <USERNAME>@$ADDRESS 'cat >> .ssh/authorized_keys'
#     echo "--SSH Configured--"
# fi

# Set Hostname
# This presumes the current hostname is defaulted to "pop-os"
echo -n "Set hostname? [y/n]: "
read -n 1 INPUT
echo ""
if [[ $INPUT == "y" ]]; then
    CURRENT=$(hostname)
    echo "Current Hostname: $CURRENT"
    echo -n "Change hostname? [y/n]: "
    read -n 1 INPUT
    echo ""
    if [[ $INPUT == "y" ]]; then
        echo -en "Enter Name: " # Print line with ignore newline and interpret escapes.
        read NAME
        echo "New Hostname: $NAME"
        echo -n "Commit Change? [y/n]: "
        read -n 1 INPUT
        echo ""
        if [[ $INPUT == "y" ]]; then
            sudo hostname $NAME
            sudo sed -i "s/$CURRENT/$NAME/g" /etc/hostname # Find and replace "pop-os" with new name
            sudo sed -i "s/$CURRENT/$NAME/g" /etc/hosts # Find and replace "pop-os" with new name
            echo "--Hostname Configured--"
        fi
    fi
fi

echo -n "Run first time setup? [y/n]: "
read -n 1 INPUT
echo ""
if [[ $INPUT == "y" ]]; then
    # Create folders in home directory
    sudo mkdir -p $HOME/repos
    sudo chown $HOME $HOME/repos
    sudo chgrp $HOME $HOME/repos

    # Dual Boot Clock Fix
    sudo timedatectl set-local-rtc 1 --adjust-system-clock

    # Remove Old LibreOffice
    sudo apt-get -y remove --purge libreoffice*
    sudo apt clean
    sudo apt-get -y autoremove

    # Install Latest LibreOffice
    flatpak -y install flathub org.libreoffice.LibreOffice
    
    # Install Nvidia Graphics Driver
    sudo apt -y install system76-driver-nvidia

    # Install snap
    sudo apt -y install snapd

    # Install flatpak
    sudo apt -y install flatpak

    # Update package manager
    sudo apt -y update

    # Perform a system update
    sudo apt -y full-upgrade 

    # Add the Snap package manager
    sudo apt -y install snapd

    # Install alacarte
    sudo apt -y install alacarte

    # Install Mailspring
    sudo snap install mailspring

    # Install Google Chrome
    sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P ~/Downloads
    sudo dpkg -i ~/Downloads/google-chrome-stable_current_amd64.deb

    # Install Telegram
    flatpak -y install flathub org.telegram.desktop

    # Install Visual Studio Code
    sudo apt -y install code

    # Install Discord
    sudo snap install discord

    # Install GIMP
    flatpak -y install flathub org.gimp.GIMP

    # Install GParted
    sudo apt -y install gparted

    # Install VLC
    sudo apt -y install vlc

    # Transfer VLC Theme
    sudo mkdir -p $HOME/.local/share/vlc/skins2
    sudo cp $HOME/os-setup/Pop\!_OS/vlc/Arc-Dark.vlt $HOME/.local/share/vlc/skins2

    # Install VirtualBox
    sudo apt -y install virtualbox

    # Install PDFSam
    sudo apt -y install pdfsam

    # Install Pomodoro
    sudo apt -y install gnome-shell-pomodoro

    # Install Remmina
    flatpak -y install flathub org.remmina.Remmina

    # Install Shotcut
    flatpak -y install flathub org.shotcut.Shotcut

    # Install gnome-tweaks
    sudo apt -y install gnome-tweaks

    # Install Foliate
    flatpak -y install flathub com.github.johnfactotum.Foliate

    # Install GNOME Clocks
    flatpak -y install flathub org.gnome.clocks

    # Install SSH
    sudo apt -y install openssh-server

    # Install 
    sudo apt -y install autokey-gtk

    # Install YouTube Downloader
    sudo apt -y install youtube-dl

    # Install Vim
    sudo apt -y install vim

    # Install neofetch
    sudo apt -y install neofetch

    # Install KColorChooser
    sudo apt -y install kcolorchooser

    # Install tmux
    sudo apt -y install tmux

    # Install Timeshift
    sudo apt -y install timeshift

    # Install imwheel
    sudo apt -y install imwheel

    # Install Microsoft fonts
    wget http://ftp.us.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.7_all.deb -P ~/Downloads
    sudo apt install ~/Downloads/ttf-mscorefonts-installer_3.7_all.deb

    # Install Piper
    sudo apt install piper

    echo "--Installations Complete--"
fi

# Prompt for system restart
echo -n "Would you like to restart now?: [y/n]: "
read -n 1 INPUT
if [[ $INPUT == "y" ]]; then
    sudo reboot
fi
echo ""


