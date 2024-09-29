# AutoHotKey Shortcuts

A collection of keyboard shortcuts implemented using *AutoHotKey*. Compile `AutoHotKey.ahk` and place it in the `shell:startup` folder or use *Task Scheduler* if the optional lock screen shortcut is desired. The `.ahk` script can be compiled into a `.exe` and run portably without the need for *AutoHotKey* installation. 

The `shortcuts` folder contains links to Windows apps which you want key bound. *AutoHotKey* points to these shortcuts instead of an executable. Shortcuts can be made through the`shell:AppsFolder`. Shortcut directories will need to be updated in `AutoHotKey.ahk` as needed.

It is easy to modify the bindings in `AutoHotKey.ahk` when using the *AHK* documentation as reference. Download the *AHK* extension for *Visual Studio Code*.

*Source:* <https://www.autohotkey.com/>

*Bindings:* <http://www.keyboard-layout-editor.com/#/gists/5f956667e8e58d30b45676237a4e8c60>

*Useful AHK Reference Code:* <https://github.com/jeebak/keyboard-windows>

*Inspired by TouchCursor:* <https://martin-stone.github.io/touchcursor/>

## Optional

This program provides an optional modification to rebind the default *Windows* lock screen shortcut from *Ctrl+L* to *Ctrl+Esc*. This is designed to prevent interference when using keyboard shortcuts for *Windows* snapping. Additionally, this is the convention *Pop!_OS* uses.

### Disable *Ctrl+L* Lock Screen Shortcut

1. Go to `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies`
2. Create a new key called `System`
3. Right click and select *New* &rarr; *Create new DWORD (32-bit) Value*
4. Name the key `DisableLockWorkstation`
5. Set the value data to `1`

### Configure Task Scheduler

*This is necessary for the alternate lock screen shortcut.*

1. Open *Task Scheduler*
2. Right click on *Task Scheduler Library* and create a new folder called `MyApps`
3. *Create New Task*
4. Set *Run At log on of any user*
5. Set *Run with highest privileges*
6. Set action to *Start a program* &rarr; `AutoHotKey.exe`
7. Uncheck *Start the task only if the computer is on AC power*
8. Uncheck *Stop the task if it runs longer than*

## Additional Shortcuts

Key bindings configured in-application rather than through AutoHotKey.*

### Windows

* *Super+A* &rarr; Action Center
* *Super+X* &rarr; Power Menu

### Visual Studio Code

* Settings Sync
  * *Shift+Alt+D* &rarr; Download Settings
  * *Shift+Alt+U* &rarr; Upload Settings

### Input Director

* *Super + Q* &rarr; Rescan Slaves
* *Ctrl + Alt+Q* &rarr; Slave Security Keys
* *Ctrl + Alt+1* &rarr; Transition to Master
* *Ctrl + Alt+2* &rarr; Transition to Slave
* *Super + Enter* &rarr; Toggle Screen Edge Transitions

### ShareX

* *Super + 1* &rarr; Capture Region
* *Super + 2* &rarr; Capture Entire Screen
* *Super + 3* &rarr; Capture Active Window
* *Super + 4* &rarr; Start/Stop Screen Recording Using Custom Region
* *Super + 5* &rarr; Start/Stop Screen Recording (GIF) Using Custom Region

### Microsoft Word / OneNote

* \* & Tab &rarr; Bullet Point



