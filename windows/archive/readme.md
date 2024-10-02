# Windows 10

1. Clone project into `C:`

## OS Configuration

1. Disable Sync
   1. Settings &rarr; Accounts &rarr; Sync your Settings &rarr; Disable Sync settings

2. Configure Dark Titlebar
   1. Start the Registry Editor and go to `HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM`
   2. Create a DWORD (32-bit) value named `AccentColorInactive`
   3. Set the hexadecimal value for both `AccentColorInactive` and `AccentColor` to `ff000000`

3. Input Director
   1. If intending to use a private LAN, set the the IP address for the master to `192.168.0.1` and `192.168.0.2` for the slave. The Default gateway can be set to `255.255.255.0` on both.
   2. Check that both machines can ping each other
   3. Master & Slave
       1. Master Preferences &rarr; Set Hotkeys to disable/enable screen edge transitions on a system to Single Hotkey &rarr; Super+Enter
       2. Global Preferences &rarr; Disable Exclude default C$,D\$,...shares for file copy/pastes
       3. Global Preferences &rarr; Disable Cursor "Water Ripple" Effect
       4. Global Preferences &rarr; Set preferred Network Interface to local ethernet adapter
   4. Master
      1. Main &rarr; Set Hotkey to return input to Master System to `Ctrl+Alt+1`
      2. Master Configuration &rarr; Add &rarr; Add `192.168.0.2`
      3. Master Configuration &rarr; Set the Hotkey for `192.168.0.2` to `Ctrl+Alt+2`
      4. Master Configuration &rarr; Enable AES Encryption for `192.168.0.2`
      5. Slave Configuration &rarr; Enable Allow only the computers listed below to take control
      6. Master Preference &rarr; Set Ctrl-Alt-Delete equivalent for slave systems to `Ctrl+Alt+Q`
      7. Master Preference &rarr; Set Lock Workstation (Win-L) equivalent for slave systems to `Ctrl+Super+L`
      8. Master Preferences &rarr; Hotkeys to disable/enable screen edge transitions on a system &rarr; `Alt+Esc`
      9. Master Preference &rarr; Set Hotkey to rescan slaves to `Super+Q`
      10. Global Preferences &rarr; Enable Run Input Director on Startup and For All Users
      11. Global Preferences &rarr; On Start &rarr; Select Input Director Enabled as a Master
      12. Global Preferences &rarr; Suppress Warning Messages &rarr; Hide Slave is Available pop-ups and Hide Slave is Unavailable pop-ups
      13. Global Preferences &rarr; Suppress Warning Messgaes &rarr; If the slave doesn't respond when taking control &rarr; Set to Inform and automatically set slave to skip
      14. Global Preferences &rarr; Set Suppress Warning Messages &rarr; If the slave doesn't respond when taking control to Inform and do not skip
   5. Slave
      1. Slave Configuration &rarr; Enable Allow only the computers listed below to take control and Add `192.168.0.1` to the list
      2. Slave Configuration &rarr; Set If directed to shutdown then to Shutdown
      3. Global Preferences &rarr; Select On Start &arr; Input Director Enabled as a Slave
   6. Pin to taskbar (Laptop Only)
4. WSL SSH
   1. Configure Launch SSH on Windows Startup
      1. Add the following autorun command to Task Scheduler

          ```powershell
          C:\Windows\System32\wsl.exe -d Ubuntu -u root service ssh start
          ```

      2. Properties -> General and set the task to Run whether user is logged on or not
      3. Properties -> Conditions and disable Start the task only if the computer is on AC power
      4. Properties -> General and set Configure for to Windows 10
   2. Set `$HOME` as the default directory on startup
      * `echo "cd ~" >> ~/.bashrc`
5. ShareX
   1. Application Settings &rarr; Paths
      1. Set ShareX personal folder to `~\ShareX`
      2. Check Use custom screenshots folder and set to `~\OneDrive\Pictures\Screenshots`
      3. Delete Sub folder pattern
   2. Hotkey Settings
       * Set all hotkeys to Shift+Alt+n where n = 1 to 5

6. Windows Terminal
   1. Fix the low-framerate issue
       * Configure Set up G-SYNC to *Enable for fullscreen mode in the Nvidia Control Panel.
   2. Open `settings.json` by selecting Settings in the menu and set the Ubuntu GUID as default

7. AutoHotKey
   1. Configure Task Scheduler

        *Note: This is necessary for the alternate lock screen shortcut.*

         1. Open Task Scheduler
         2. Right click on Task Scheduler Library and create a new folder called `MyApps`
         3. Create a new Basic task
         4. Set Run only when user is logged on
         5. Set Run with highest privileges
         6. Set trigger as At log on
         7. Set action to Start a program &rarr; `AutoHotKey.exe`
         8. Disable Start the task only if the computer is on AC power
         9. Disable Stop the task if it runs longer than

   2. Disable *Ctrl+L* Lock Screen Shortcut (Optional)

        *Note: The AutoHotKey script provides an optional modification to rebind the default Windows lock screen shortcut from `Ctrl+L` to `Ctrl+Esc`. This is designed to prevent interference when using keyboard shortcuts for Windows snapping. In addition, this is the convention Pop!_OS uses.*

         1. Go to `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies`
         2. Create a new key called `System`
         3. Right click and select New &rarr; Create new DWORD (32-bit) Value
         4. Name the key `DisableLockWorkstation`
         5. Set the value data to `1`
8. Spotify
   1. Settings &rarr; Streaming quality &rarr; Set to Very High
   2. Settings &rarr; Disable Show Friend Activity
   3. Create a storage folder
   4. Settings &arrr; Advanced Settings &rarr; Set Offline songs storage to the designated folder
9. Barrier
   1. If intending to use a private LAN, set the the IP address for the master to `192.168.0.1` and `192.168.0.2` for the slave. The Default gateway can be set to `255.255.255.0` on both.
   2. Set to launch on startup
      * `Super+R` &rarr; Run &rarr; Open `shell:startup` and copy a shortcut of Barrier it
   3. Settings &rarr; Screen name &rarr; Set to `<COMPUTER_NAME`
   4. Settings &rarr; Enable Hide on startup
   5. Disable Auto config
   6. Enter the IP address of the master
10. Telegram
    1. Enable Night Mode
    2. Settings &rarr; Advanced &rarr; Enable
       1. Launch Telegram when system starts
       2. Launch minimized
       3. Place Telegram in "Send to" menu
    3. Settings &rarr; Chat Settings &rarr; Themes &rarr; Night
11. Microsoft Word
    1. Download and install Latin Modern
        1. Latin Modern Roman 12 Regular
        2. Latin Modern Roman 12 Italic
        3. Latin Modern Roman 12 Bold
    2. Home &rarr; Font Toolbar Group &rarr; Select Pop-out Arrow
       1. Set Font to Times New Roman
       2. Set Size to 12
       3. Set Font style to Regular
       4. Select Set As Default
       5. Select All documents based on the Normal.dotm template
       6. Select Yes
    3. Insert &rarr; Equation &rarr; Conversions Toolbar Group rarr; Select Pop-Out Arrow
       1. Set Default font for math regions to Latin Modern Math
       2. Select Defaults ...
       3. Select Yes

## Programs

* Google Chrome
* Firefox
* GroupMe
* Input Director
* WinDirStat
* Advanced Renamer
* PdaNet
* 7-Zip
* Ear Trumpet
* AutoHotKey
* WindowGrid
* Ubuntu WSL
* GIMP
* VLC
* Spotify
* OneNote
* OneNote 2016
* Telegram (Website Download)
* Facebook Messenger
* Discord
* Your Phone
* Steam
* Epic Games
* Rockstar Games
* LOOT
* Vortex
* Origin
* GOG Galaxy
* Battle.​net
* Netflix
* Hulu
* Amazon Prime
* iTunes
* Libby
* Microsoft Office
* Todoist
* myHomework
* Focus 10
* Windows Terminal
* Kindle
* Bookshelf
* Adobe Digital Editions
* PDFsam
* ShareX
* IntelliJ
* CLion
* Visual Studio Code
* Notepad++
* VirtualBox
* VMWare
* EaseUS Partition Master
* Zoom
