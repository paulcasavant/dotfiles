# macOS

## Setup
* Add configuration info to Hammerspoon `config.lua`
  1. `cp $HOME/repos/dotfiles/mac_os/scripts/hammerspoon/config.lua.template $HOME/repos/dotfiles/mac_os/scripts/hammerspoon/config.lua`
  2. Populate `config.lua` with configuration info
  3. Reload *Hammerspoon*
* Run the environment setup script: `source $HOME/repos/dotfiles/mac_os/scripts/setup.sh`
* Execute script to move the Karabiner Elements configuration file: `$CONFIG_PATH/karabiner-elements/sync_karabiner.sh`

## Settings
  * Enable key-repeating: `defaults write -g ApplePressAndHoldEnabled -bool false`
  * Enable keyboard navigation: Settings > Keyboard -> *Enable Keyboard navigation*
  * Set function keys as default
    * Settings > Keyboard -> Keyboard Shortcuts... > Function Keys > Enable *Use F1, F2, etc. keys as standard function keys*
  * Settings > Lock Screen > Set Turn display off on power adapter when inactive to For 10 minutes
  * Settings > Lock Screen > *Set Start Screen Saver when inactive* to *Never*
  * Sounds > Sound Effects > Change *Alert Sound* to *Jump*
  * Finder > Settings... > Advanced > Set *When performing a search* to *Search the Current Folder*
  * Finder > Settings... > Advanced > Enable *Show all filename extensions*
  * Finder > Settings... > General > Set *New Finder windows show* to `<USERNAME>`
  * Finder > Settings... > Sidebar
      * Disable *Airdrop*
      * Disable *Recent Tags*
      * Enable *Pictures*, `<COMPUTER_NAME>`
  * Finder > Customize Toolbar... > *Add Airdrop to toolbar*

## Applications
* [Menu Bar Controller for Sonos](https://apps.apple.com/us/app/menu-bar-controller-for-sonos/id1357379892?mt=12)
    * Settings > Shortcuts > Set *Increase/Decrease volume on current group* to <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>Q</kbd>/<kbd>E</kbd>
    * Settings > Shortcuts > Uncheck *Show pop-up when using shortcuts*
* [MagicQuit](https://magicquit.com/)
* [VIA](https://github.com/the-via/releases/releases)
* [ChatGPT](https://openai.com/chatgpt/download/)
* [AppCleaner](https://freemacsoft.net/appcleaner/)
* [LG TV Control for macOS](https://github.com/cmer/lg-tv-control-macos)
  * Settings > Lock Screen > Set *Turn display off* settings to an appropriate timeout
  * Settings > Battery > Options... > Enable *Prevent automatic sleeping on power adapter when the display is off*
  * Manually test sleep mode using `pmset sleepnow` and `pmset displaysleepnow`
  * Write TV to config file: `~/bin/lgtv auth <IP> "BedroomTV"` 
  * Set TV as default: `~/bin/lgtv setDefault "BedroomTV"` 
  * Test connection: `~/bin/lgtv off && sleep 2 && ~/bin/lgtv on` 
* [Homebrew](https://brew.sh/)
* [ShortcutDetective](https://www.irradiatedsoftware.com/labs/): `brew install --cask shortcutdetective`
* [Obsidian](https://obsidian.md/)
* [LM Studio](https://lmstudio.ai/)
* [Dropover](https://apps.apple.com/us/app/dropover-easier-drag-drop/id1355679052?mt=12)
* [Amphetamine](https://apps.apple.com/us/app/amphetamine/id937984704?mt=12)
* [Whisky](https://github.com/Whisky-App/Whisky)
* [PiPad](https://apps.apple.com/us/app/pipad-calculation-note/id1482575592)
* [DaisyDisk](https://apps.apple.com/us/app/daisydisk/id411643860?mt=12)
* [MagicNotch](https://apps.apple.com/us/app/magicnotch-elegant-shortcuts/id6447055708?mt=12)
* [iTerm2](https://iterm2.com/downloads.html)
  * Shell: [ohmyzsh](https://ohmyz.sh/)
  * Profiles > Colors
    * Foreground: `dcb755`
    * Background: `111010`
    * Color Presets: [Gruvbox Dark](https://github.com/herrbischoff/iterm2-gruvbox)
  * Profiles > Window
    * Transparency: `2`
    * Blur: `2`
  * Preferences > Appearence > General > Set *Theme* to *Minimal*
  * Profiles > Default > Keys > Key Mappings > Click *+*
    * Set *Keyboard Shortcut* to `command`+`left` and Action to *Send Hex Code* 0x01 for Home
    * Set *Keyboard Shortcut* to `command`+`right` and *Action* to *Send Hex Code* 0x05 for End
* [Python](https://www.python.org/downloads/macos/)
* [SwitchAudioSource](https://github.com/deweller/switchaudio-osx): `brew install switchaudio-osx`
* [BetterDisplay](https://github.com/waydabber/BetterDisplay)
  * Set resolution to 2304x1296 and enable HDR
  * Disable volume control (conflict with Hammerspoon): Settings > Keyboard > Disable *Listen to native audio keys*
  * Settings > LG TV SSCR2 > Video Control Settings > Enable *Dim display brightness on screen saver or lock* and set to *50%*
  * Displays > General Settings > Additional settings > Enable *Reinitialize this display on wake*
* [Hammerspoon](https://github.com/Hammerspoon/hammerspoon/releases/)
  1. `pip install wakeonlan`
  2. Edit `scripts/config.lua` and update the configuration variables
* [Karabiner-Elements](https://karabiner-elements.pqrs.org/)
* [Mozilla Firefox](https://www.mozilla.org/en-US/firefox/all/#product-desktop-release)
  * Enable Vimium C Homepage
    1. Go to the [debugging](about:debugging#/runtime/this-firefox) page in firefox and find the <EXTENSION_ID> for the *NewTab Adapter* extension
    2. Set home page to the Custom URL `moz-extension://<EXTENSION_ID>/newtab.html`
  * Fix HDR
    1. Open `about:config` in Firefox > disable `media.mediasource.webm.enabled`
    2. Restart Firefox
* [Streaks](https://apps.apple.com/us/app/streaks/id963034692)
* [Telegram](https://desktop.telegram.org/)
  * Use Automator to export *application_launchers/Telegram.sctp* as *~/Launchers/Telegram.app* and set it to run on startup
* [Discord](https://discord.com/download)
  * Use Automator to export *application_launchers/Discord.sctp* as *~/Launchers/Telegram.app* and set it to run on startup
* [Visual Studio Code](https://code.visualstudio.com/download)
* [Microsoft Office](https://www.office.com/)
* [Microsoft OneNote](https://www.office.com/)
* [Microsoft OneDrive](https://www.office.com/)
* [Spotify](https://www.spotify.com/us/download/mac/)
* [1Password](https://1password.com/downloads/mac/)
* Gaming
  * Libraries
    * [Epic Games](https://store.epicgames.com/en-US/download)
    * [Steam](https://store.steampowered.com/about/)
    * [Battle.net](https://download.battle.net/)
  * Games
    * Company of Heroes 2
    * Hearthstone
    * Slay the Spire
    * LIMBO
    * Griftlands
* Safari Extensions
  * [DarkReader for Safari](https://apps.apple.com/us/app/dark-reader-for-safari/id1438243180)
  * [Vimari](https://apps.apple.com/us/app/vimari/id1480933944?mt=12)
  * [1Password](https://apps.apple.com/us/app/1password-for-safari/id1569813296?mt=12)
  * [1Blocker](https://apps.apple.com/us/app/1blocker-ad-blocker/id1365531024)
* [Parcel](https://apps.apple.com/us/app/parcel-delivery-tracking/id639968404?mt=12)
* [Shazam](https://apps.apple.com/us/app/shazam-identify-songs/id897118787?mt=12)
* [CrystalFetch](https://apps.apple.com/us/app/crystalfetch-iso-downloader/id6454431289?mt=12)
* [UTM](https://apps.apple.com/us/app/utm-virtual-machines/id1538878817?mt=12)
* [Brother iPrint&Scan](https://apps.apple.com/us/app/brother-iprint-scan/id1193539993?mt=12)
* [MarginNote 4](https://apps.apple.com/us/app/marginnote-4/id1531657269)
* [Notability](https://apps.apple.com/us/app/notability-notes-pdf/id360593530)
* [GoodNotes](https://apps.apple.com/us/app/goodnotes-6/id1444383602)
* [Magnet](https://apps.apple.com/us/app/magnet/id441258766?mt=12)
* [yabai](https://github.com/koekeishiya/yabai/wiki)
  * `brew install koekeishiya/formulae/yabai`
  * `brew install terminal-notifier`
  * Stop *yabai* from running at login: System Settings > General > Login Items & Extensions > Unset *yabai*
* [tadam](https://apps.apple.com/us/app/tadam/id531349534?mt=12)
* [Rocket](https://matthewpalmer.net/rocket/)
  * Preferences > General -> Enable *Use double key trigger*
  * Add to Disabled Apps:
    * Telegram
    * Visual Studio Code 
* [Mac Mouse Fix](https://macmousefix.com/)
  * Scrolling > Enable Reverse Direction 
  * Scrolling > Set Smoothness to Regular
  * Scrolling > Set Speed to High
* [Raycast](https://www.raycast.com/)
  * Applications
  * Calculator
  * Calendar
  * Clipboard History
  * Color Picker
  * Define Word
  * Developer
  * Floating Notes
  * Kill Process
  * Navigation
  * Quicklinks
  * Raycast
  * Raycast AI
  * Raycast Settings
  * Raycast for Teams
  * Screenshots
  * Script Commands
  * Search Contacts
  * Search Emoji & Symbols
  * Search Files
  * Shortcuts
  * Snippets
  * Start Typing Practice
  * System
  * System Settings
  * Test Internet Speed
  * Translate
  * Visual Studio Code
  * Window Management
  * Yabai
* [Calendar 366 II](https://apps.apple.com/us/app/calendar-366-ii/id1265895169?mt=12)
* [Logitech G HUB (G502 mouse)](https://www.logitechg.com/en-us/innovation/g-hub.html)
  * Assign Mouse Buttons G4/G5 to macros for Forward/Back
    * Forward: <kbd>Cmd</kbd> + <kbd>]</kbd>
    * Back: <kbd>Cmd</kbd> + <kbd>[</kbd>
  * Assign Mouse Buttons G7/G8 to G4/G5 (Mac Mouse Fix)
  * Assign the `Onboard Profile Cycle` button to launch Spotlight
* [TextSniper](https://apps.apple.com/us/app/textsniper-ocr-copy-paste/id1528890965?mt=12)
* [InYourFace](https://apps.apple.com/us/app/in-your-face-meeting-reminder/id1476964367?mt=12)
* [Swish](https://highlyopinionated.co/swish/)
    * Advanced > Keyboard -> Disable Arrow Hotkeys (Allows PageUp/PageDown to be used) 
* [Multitouch](https://multitouch.app/)
    * Trackpad > Three Finger Touch -> Middle Click
    * Trackpad > Three Finger Click -> Middle Click
* [Hidden Bar](https://apps.apple.com/us/app/hidden-bar/id1452453066?mt=12)
* [Gestimer](https://apps.apple.com/us/app/gestimer-2/id6447125648?mt=12)
* [WaterMinder](https://apps.apple.com/us/app/waterminder-water-tracker/id1415257369?mt=12)
* [Zoom](https://zoom.us/download?os=mac)
* [Scan Thing](https://apps.apple.com/us/app/scan-thing-scan-everything/id1556313108?mt=12)
* [GIMP](https://www.gimp.org/downloads/)
* [Inkscape](https://inkscape.org/)
* [Inspect](https://github.com/mhdhejazi/Inspect)
* [Klack](https://apps.apple.com/us/app/klack/id6446206067?mt=12)
* [Amphetamine](https://apps.apple.com/us/app/amphetamine/id937984704?mt=12)
* [TechniCalc Calculator](https://apps.apple.com/us/app/technicalc-calculator/id1504965415)
* [Maccy](https://maccy.app/)
* [tmux](https://github.com/tmux/tmux/wiki)
  * `brew install tmux`
* [neofetch](https://github.com/dylanaraps/neofetch): `brew install neofetch`
* [nmap](https://nmap.org/): `brew install nmap`
* [neovim](https://neovim.io/)
  * `brew install neovim`
  * Install *neovim* Python IPC
    * `pip install pynvim`
  * Install font: `brew install font-hack-nerd-font`
    * iTerm2 > Settings > Profiles > Text > Set Font to *Hack Nerd Font Mono*
  * Install Lua language server: `brew install lua-language-server`
  * Enable tmux clipboard support: iTerm2 > Settings... > General > Selection Enable *Applications in terminal may access clipboard*
  * Install packages in *neovim* after linking configs: `:PackerSync`
* [gitleaks](https://github.com/gitleaks)
    * `brew install gitleaks`