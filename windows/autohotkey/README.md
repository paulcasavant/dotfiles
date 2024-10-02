# windows-control automations

## 1. Dependencies

1. Install DisplayFusion from Steam
2. Install: [LGTV Companion](https://github.com/JPersson77/LGTVCompanion)
3. Install [AutoHotKey v2.0](https://www.autohotkey.com/)
4. Install Soco-CLI: `pip install soco-cli`
5. Compile *hdr.cpp* with *hdr.h*
   1. Install MSYS2/UCRT64
      * Open console, and run `pacman -Sy`
      * Install GCC: `pacman -S mingw-w64-x86_64-gcc`
      * Install GDB: `pacman -S mingw-w64-x86_64-gdb`
      * Add C:\msys64\mingw64\bin to PATH in System Variables
   2. From PowerShell, run `cd C:\repos\windows-control\; g++ -o hdr.exe hdr.cpp hdr.h`
6. Configure Audio Using [AudioDeviceCmdlets](https://github.com/frgnca/AudioDeviceCmdlets)
   1. PowerShell (Administrator): `Install-Module -Name AudioDeviceCmdlets`
   2. Capture device IDs using `Get-AudioDevice -List`

## 2. Configure **Task Scheduler** to run `keyboard_shortcuts.ahk` on Startup

1. Start Task Scheduler, and click **Create Task…** in the **Actions** pane.
2. Name the task **Run Keyboard Shortcuts**
3. Select **Run whether user is logged on or not** under **Security Options**
4. Go to the **Triggers** tab, select **New...**
   * Set **Begin the task** to **At startup**
5. Go to the **Actions** tab, select **New...**, and set **Action** to **Start a program**
6. Set **Program/script** to `<LGTV_COMPANION_PATH>\LGTVcli.exe`
7. Set **Add arguments** to `-sethdmi<PC_HDMI_NUM>`

## 3. Configure **Task Scheduler** to Switch TV Input to PC on Startup

1. Start Task Scheduler, and click **Create Task…** in the **Actions** pane.
2. Name the task **Switch HDMI to PC**
3. Select **Run only when user is logged on** under **Security Options**
4. Go to the **Triggers** tab, select **New...**
   * Set **Begin the task** to **At log on**
5. Go to the **Actions** tab, select **New...**, and set **Action** to **Start a program**
6. Set **Program/script** to `"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"`
7. Set **Add arguments** to `C:\repos\windows-control\keyboard_shortcuts.ahk`

## 4. Configure Wake-on-LAN: [homebridge-wake-on-lan](https://github.com/paulcasavant/homebridge-wake-on-lan)