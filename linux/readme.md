# Pop!_OS

## OS Install (Dual Boot)

1. Free up ~100gb of space in Windows Disk Manager
1. Free up an additional 40-128GB (on external drive if available)
1. Create a Pop!_OS boot drive using Rufus
1. Boot to the drive and use GParted to allocate the following partitions:
   1. Pop!_OS EFI: 512MiB fat32
   1. Pop!_OS Swap: 4096MiB linux
   1. Pop!_OS Root: \<remaining space\>MiB ext4
1. Select all partitions and format

## OS Configuration

1. Storage Drive(s)
   1. If allocated storage will be a partition and not a standalone drive, open GParted and create an ntfs partition in the remaining unallocated space

        *Note: If the partition is allocated on the boot drive, create the partiton through GParted in Linux rather than in Windows Disk Manager.*
   1. Find the ntfs partition UUID by running `sudo blkid | grep ntfs | grep -i <Partition Name>`
   1. Run `sudo mkdir /mnt/<Partition Name>`
   1. Add the following line to `/etc/fstab` with the correct UUID:

        *Note: If the partition name has a space in it, replace the space character in the name with the escape sequence `\040`*

      ```bash
        UUID=<Partition UUID>  /mnt/Storage ntfs defaults  0  2
      ```

   1. `sudo mount --all`
   1. Drag the partiton folder to the sidebar
1. Manually install these programs
   1. VMWare
      * Configure Windows VM
        1. Enable Intel Virtualization in the BIOS
        1. Install Windows 10 Pro from ISO on Storage drive
           1. Store virtual disk as a single file
           1. Memory: 4096MB
           1. Processors: 4
           1. Hard Disk: ~60GB (if available)
        1. Download VMWare Tools
        1. File &rarr; Player Preferences &rarr; Disable Confirm before closing a virtual machine
        1. Add a new CD/DVD Drive
        1. Reboot VM
        1. Virtual Machine &rarr; Install VMWare Tools
        1. Launch installer from Devices and drives in Windows
        1. Windows Configuration
           1. Sign into Microsoft account and create a pin
           1. Configure auto-hide taskbar
              1. Open the Registry Editor
              1. Go to `HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3`
              1. On the right, modify the binary (REG_BINARY) value Settings. Set the first pair of digits in the second row to 03 to make the taskbar auto-hide. Change this value to 02 to disable it.
              1. Restart the Explorer shell in Task Manager. (Logging out will not work.)
        1. Right Click Taskbar &rarr; Disable Show Cortona button
        1. Right Click on an image and select Set as desktop backgroun to change the wallpaper
        1. Uninstall all unecessary apps
        1. Install Windows Updates
        1. Configure Windows 10 application launcher shortcut
            1. Create a new alacarte entry with a custom icon called "Windows 10" that runs the following:

                  *Note: Make sure to update the path.*

               ```bash
                  tmux new -d 'vmplayer /mnt/Storage/VMWare/Windows\ 10\ x64/Windows\ 10\ x1.vmx'
               ```

   1. Insync
1. Google Drive
   1. Run `nautilus /run/user/1000/gvfs` and drag both drive folders to the sidebar
   1. Rename the first to `Personal`
   1. Rename the second to `School`
1. Insync (OneDrive)
   1. Set base folder to `/mnt/Storage/OneDrive`
   1. Preferences &rarr; Set Zoom to 150%
   1. Run `nautilus /mnt/Storage` and drag OneDrive to the sidebar
1. Find a desired wallpaper on OneDrive and right click to select 
1. Copy Icons from OneDrive to `~/Pictures/Icons`
1. Spotify
   1. High DPI Fix (Not necessary below 4K):
   1. Open `/usr/share/applications/spotify.desktop` and add or change the `Excec=spotify` line to the following

      ```bash
        Exec=spotify --force-device-scale-factor=1.0 %U
      ```

      * If that does not work, try changing the command to `spotify --force-device-scale-factor=1.0 %U` in alacarte
   1. Set Streaming quality to Very High
   1. Disable Show Friend Activity
   1. Create a folder called `/mnt/Storage/Spotify/Pop!_OS` and direct the Offline Songs Storage to it
   1. GNOME Settings &rarr; Notifications &rarr; Spotify &rarr; Disable Notification Popups
1. Libre Office
   1. Verify Times New Roman works
   1. Tools &rarr; Options &rarr; LibreOffice Writer &rarr; Basic Fonts (Western) &rarr; Set all fonts to Times New Roman
   1. Tools &rarr; Options &rarr; LibreOffice &rarr; View &rarr; set Icon style to Sukapura
   1. Tools &rarr; Options &rarr; Advanced &rarr; Enable experimental features (may be unstable)
   1. View (from toolar) &rarr; User Interface... &rarr; Tabbed &rarr; Apply to All
1. Telegram
    1. Settings &rarr; Advanced &rarr; Enable
       * Launch Telegram when system starts
       * Launch minimized
       * Disable Show tray icon
    1. Settings &rarr; Chat Settings &rarr; Themes &rarr; Night
1. Visual Studio Code
    1. Download the Settings Sync extensions
    1. Sign into GitHub
    1. Use Shift+Alt+D to download latest settings
1. Flameshot
    1. GNOME Settings &rarr; Keyboard Shortcut &rarr; Disable Save a screenshot to Pictures
    1. GNOME Settings &rarr; Keyboard Shortcut &rarr; Add a shortcut called "Take Flameshot" that runs the command `flameshot gui` and bind it to `PrtScr`
    1. Configuration &rarr; General &rarr; Launch at startup
    1. Disable Show tray icon
    1. Disable Show help message
    1. Disable Show desktop notications
    1. Set the Main Color to be similar to the teal Pop!_OS accent color
    1. Set the Contrast Color to be black
1. JetBrains Clion
    1. Sign in with JetBrains account
    1. Enable Sync Plugins Silently
    1. Settings &rarr; Editor &rarr; Color Scheme &rarr; Material Darker
    1. Compile code as a test
    1. Update icon through alacarte
1. JetBrains IntelliJ
    1. Sign in withJetBrains account
    1. Download OpenJDK
    1. Enable Sync Plugins Silently
    1. Compile code as a test
    1. Update icon through alacarte
1. Firefox
    1. Update icon through alacarte
1. kcolorchooser
    1. Update icon through alacarte
1. Timeshift
    1. Create an ~50+GB ext4 partition called "Pop!_OS Timeshift"
    1. Set to RSYNC Snapshots
    1. Set to take weekly snapshot while keeping 3 copies (or more if space affords)
    1. Set to include all files
    1. Manually create a snapshot
    1. Update icon through alacarte
1. Configure GNOME Tweaks
    1. Top Bar &rarr; Enable Battery Percentage (Laptop Only)
    1. Enable Windows Titlebars &rarr; Maximize and Minimize
    1. Enable Windows &rarr; Center New Windows
1. Configure GNOME Extensions
    1. Download Extensions Sync from the extensions webpage
    1. Create a personal token (or regenerate it if one already exists for the system) on GitHub &rarr; Settings &rarr; Developer settings &rarr; Personal access tokens entitled GNOME Extension Sync (\<computer name\>) and copy the ID to clipboard
    1. Paste into Extensions Sync through Preferences &rarr; Github User Tokien
    1. Go to GitHub &rarr; Your gists &rarr; `<USERNAME>/extensions` and copy the Gist ID from the URL
    1. Paste the Gist ID into Preferences &rarr; Github Gist Id
    1. Select Download from Extensions Sync
    1. Enter email address into Gravatar
    1. Apply system specific settings
       * Desktop
         1. Connect phone with GSConnect
         1. Set Dash to dock to show on the right side
         1. Set Custom hot corners to Show overview on top right
       * Laptop
         1. Connect phone with GSConnect
         1. Set Dash to dock to show on the left side
         1. Disable Push to show in Dash to dock
         1. Set Custom hot corners to Show overview on top left
1. Set Weather location
1. Set gaps to zero in tiling manager
1. Configure GIT cached credentials
    1. Run `git config --global credential.helper cache` to enable it

        *Note: It can be disabled by running `git config --global --unset credential.helper`*
    1. Run `git config --global credential.helper 'cache --timeout=7200'` to set a 2 hour timout in seconds
1. Configure mouse scroll speed
      1. [Configure imwheel](https://io.bikegremlin.com/11541/linux-mouse-scroll-speed/)
1. JetBrains CLion
1. JetBrains IntelliJ
1. Zoom
1. Spotify
1. 1Password
    1. `Ctrl + Shift + P` &rarr; "Show 1Password"
1. Keyboard Shortcuts
    1. `PrintScreen` &rarr; Copy a screenshot of an area to clipboard

## Programs

* alacarte
* Mailspring
* Chrome
* Telegram
* Spotify
* CLion
* IntelliJ
* VS Code
* Discord
* GIMP
* Gparted
* Insync
* VLC
* VirtualBox
* PDFSam
* Pomodoro
* Remmina
* Shotcut
* gnome-tweaks
* Vim
* Foliate
* Zoom
* EasyTether
* GNOME Clocks
* openssh-server
* youtube-dl
* Vim
* VMWare
* KColorChooser
* tmux
* Timeshift
* 1Password
* Piper

## GNOME Extensions

* Alt-Tab Switcher Popup Delay Removal
* Bluetooth quick connect
* Blyr
* Dash to Dock
* Extension Update Notifier
* Force Quit
* GSConnect
* Places Status Indicator
* Pomodoro (from apt)
* Quick Close in Overview
* Disconnect Wifi
* Right-click For Touch Screen
* Sound Input & Output Device Chooser
* Tweaks in System Menu
* Workspace Scroll
* NoAnnoyance v2
* ShellTile
* Extensions Sync
* Caffeine

## References

1. [POP OS! Hibernate enable step by step Complete tutorial and references.](https://medium.com/@csatyendra02/pop-os-hibernate-enable-step-by-step-complete-tutorial-and-references-601e0ca4c96e)