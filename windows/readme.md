# Windows

## Setup

* Set a static IP for TV
* Install [LGTV Companion](https://github.com/JPersson77/LGTVCompanion)
* Install [DisplayFusion](https://store.steampowered.com/app/227260/DisplayFusion/)
* Install [AutoHotKey v2.0](https://www.autohotkey.com/)
* Install [Soco-CLI](https://github.com/avantrec/soco-cli): `pip install soco-cli`
* Install [AudioDeviceCmdlets](https://github.com/frgnca/AudioDeviceCmdlets)
   1. PowerShell (Administrator): `Install-Module -Name AudioDeviceCmdlets`
   2. Capture device IDs using `Get-AudioDevice -List`
* Configure [homebridge-wake-on-lan](https://github.com/paulcasavant/homebridge-wake-on-lan)
* Compile HDR Toggle:
   1. Install MSYS2/UCRT64
      * Open console, and run `pacman -Sy`
      * Install GCC: `pacman -S mingw-w64-x86_64-gcc`
      * Install GDB: `pacman -S mingw-w64-x86_64-gdb`
      * Add C:\msys64\mingw64\bin to PATH in System Variables
   2. From PowerShell, run `g++ -o hdr.exe hdr.cpp hdr.h`
* Configure *Task Scheduler* to run `init.ahk` on Startup
    1. Start Task Scheduler, and click *Create Task…* in the *Actions* pane.
    2. Name the task *Start AHK*
    3. Select *Run only when user is logged on* under *Security Options*
    4. Go to the *Triggers* tab, select *New...*
        * Set *Begin the task* to *At log on*
        * Click *OK* 
    5. Go to the *Actions* tab, select *New...*, and set *Action* to *Start a program*
    6. Set *Program/script* to `"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"`
    7. Set *Add arguments* to `%SCRIPT_PATH%\windows\scripts\autohotkey\init.ahk`

## Applications
* [TaskbarX](https://apps.microsoft.com/detail/9PCMZ6BXK8GH?hl=en-us&gl=US&ocid=pdpshare)
   * Fix Steam Big Picture w/ Hidden Taskbar:
      1. Open *TaskbarX Configurator*
      2. Style > Style > Opaque > Apply
      3. Startup > Set Delay to 0 sec > Create > Apply
* [TranslucentTB](https://apps.microsoft.com/detail/9PF4KZ2VN4W9?hl=en-us&gl=US&ocid=pdpshare)
   1. Right Click *TranslucentTB* Tray Icon
   2. Desktop > Opaque
* [Twinkle Tray](https://github.com/xanderfrangos/twinkle-tray)
* [Apollo](https://github.com/ClassicOldSong/Apollo)
* [Google Chrome](https://www.google.com/chrome/)
* [Firefox](https://www.mozilla.org/firefox/)
* [WinDirStat](https://windirstat.net/)
* [7-Zip](https://www.7-zip.org/)
* [AutoHotKey](https://www.autohotkey.com/)
* [WindowGrid](https://windowgrid.net/)
* [WSL](https://ubuntu.com/wsl)
* [GIMP](https://www.gimp.org/)
* [VLC](https://www.videolan.org/vlc/)
* [Spotify](https://www.spotify.com/)
* [OneNote](https://www.onenote.com/)
* [Telegram (Website Download)](https://desktop.telegram.org/)
* [Signal](https://signal.org/)
* [Discord](https://discord.com/)
* [Steam](https://store.steampowered.com/)
* [Epic Games](https://www.epicgames.com/store/en-US/)
* [Rockstar Games](https://www.rockstargames.com/)
* [Vortex](https://www.nexusmods.com/about/vortex/)
* [EA Games](https://www.ea.com/)
* [GOG Galaxy](https://www.gog.com/galaxy)
* [Battle.net](https://www.battle.net/)
* [Netflix](https://www.netflix.com/)
* [Hulu](https://www.hulu.com/)
* [Amazon Prime](https://www.microsoft.com/store/productId/9P6RC76MSMMJ?ocid=pdpshare)
* [Libby](https://www.overdrive.com/apps/libby/)
* [Microsoft Office](https://www.microsoft.com/en-us/microsoft-365)
* [Visual Studio Code](https://code.visualstudio.com/)
* [VirtualBox](https://www.virtualbox.org/)
* [Zoom](https://zoom.us/)
* [Neovim](https://neovim.io/)
* [VIA](https://caniusevia.com/)
* [Vial](https://get.vial.today/download/)
* [PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/)
* [DisplayFusion Pro](https://www.displayfusion.com/)
* [soco-cli](https://github.com/avantrec/soco-cli)
 