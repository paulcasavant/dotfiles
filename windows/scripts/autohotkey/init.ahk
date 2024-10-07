#Requires AutoHotkey v2.0

#Include config.ahk

; CapsLock -> Ctrl
CapsLock::Ctrl

; Ctrl+H/J/K/L -> Left/Down/Up/Right
^h::Send("{Left}")
^j::Send("{Down}")
^k::Send("{Up}")
^l::Send("{Right}")

; Alt+C/A/V/X -> Ctrl+C/A/V/X
!c::Send("^c")
!a::Send("^a")
!v::Send("^v")
!x::Send("^x")

; Ctrl+Volume Down -> Set Sonos Relative Volume -1 
^Volume_Down::Run A_ComSpec " /c " SONOS_PATH " `"Bedroom Speaker`" relative_volume -1",,"Hide"

; Ctrl+Volume Up -> Set Sonos Relative Volume +1 
^Volume_Up::Run A_ComSpec " /c " SONOS_PATH " `"Bedroom Speaker`" relative_volume +1",,"Hide"

; Menu+Volume Down -> Set Sonos Relative Volume -1 
F13::Run A_ComSpec " /c " SONOS_PATH " `"Bedroom Speaker`" relative_volume -1",,"Hide"

; Menu+Volume Up -> Set Sonos Relative Volume +1 
F14::Run A_ComSpec " /c " SONOS_PATH " `"Bedroom Speaker`" relative_volume +1",,"Hide"

; Hyper+P -> Switch TV Video Input to PC, Switch Audio to TV
#^!P::{
  Run A_ComSpec " /c `"" LGTV_CLI_PATH "`" -poweron",,"Hide"
  Run A_ComSpec " /c `"" LGTV_CLI_PATH "`" -sethdmi4",,"Hide"
  Run A_ComSpec " /c " SONOS_PATH " `"Bedroom Speaker`" switch_to_tv",,"Hide"
}

; Hyper+L -> Switch TV Video Input to Laptop, Switch Audio to TV
#^!L::
{
  Run A_ComSpec " /c `"" LGTV_CLI_PATH "`" -poweron",,"Hide"
  Run A_ComSpec " /c `"" LGTV_CLI_PATH "`" -sethdmi3",,"Hide"
  Run A_ComSpec " /c " SONOS_PATH " `"Bedroom Speaker`" switch_to_tv",,"Hide"
}

; Hyper+F1 -> Normalize Resolution with HDR On
#^!F1::
{
  Run A_ComSpec " /c taskkill /IM Telegram.exe /F",,"Hide"
  Run A_ComSpec " /c `"" DISPLAY_FUSION_PATH "`" -monitorloadprofile Desk",,"Hide"
  Sleep 2000
  Run A_ComSpec " /c " HDR_PATH " on",,"Hide"
  Run A_ComSpec " /c `"" TELEGRAM_PATH "`" -scale 135 -startintray",,"Hide"
}

; Hyper+F2 -> Normalize Resolution with HDR Off
#^!F2::
{
  Run A_ComSpec " /c taskkill /IM Telegram.exe /F",,"Hide"
  Run A_ComSpec " /c `"" DISPLAY_FUSION_PATH "`" -monitorloadprofile Desk",,"Hide"
  Sleep 2000
  Run A_ComSpec " /c " HDR_PATH " off",,"Hide"
  Run A_ComSpec " /c `"" TELEGRAM_PATH "`" -scale 135 -startintray",,"Hide"
}

; Hyper+F3 -> Normalize Resolution (Zoomed) with HDR On
#^!F3::
{
  Run A_ComSpec " /c taskkill /IM Telegram.exe /F",,"Hide"
  Run A_ComSpec " /c `"" DISPLAY_FUSION_PATH "`" -monitorloadprofile Recliner",,"Hide"
  Sleep 2000
  Run A_ComSpec " /c " HDR_PATH " on",,"Hide"
  Run A_ComSpec " /c `"" TELEGRAM_PATH "`" -scale 85 -startintray",,"Hide"
}

; Hyper+F4 -> Normalize Resolution (Zoomed) with HDR Off
#^!F4::
{
  Run A_ComSpec " /c taskkill /IM Telegram.exe /F",,"Hide"
  Run A_ComSpec " /c `"" DISPLAY_FUSION_PATH "`" -monitorloadprofile Recliner",,"Hide"
  Sleep 2000
  Run A_ComSpec " /c " HDR_PATH " off",,"Hide"
  Run A_ComSpec " /c `"" TELEGRAM_PATH "`" -scale 85 -startintray",,"Hide"
}

; Menu+. (>) -> Increase TV brightness by 10
#^!.::
{
  keywait "F13"
  Run A_ComSpec " /c python " SET_BRIGHTNESS_SCRIPT_PATH " increase",,"Hide"
}

; Menu+, (<) -> Decrease TV relative brightness by 10
#^!,::
{
  keywait "F14"
  Run A_ComSpec " /c python " SET_BRIGHTNESS_SCRIPT_PATH " decrease",,"Hide"
}

; Menu+/ -> Set TV brightness to maximum
#^!/::
{
  Run A_ComSpec " /c `"" LGTV_CLI_PATH "`" -backlight 100",,"Hide"
}

; Menu+m -> Set TV brightness to low
#^!m::
{
  Run A_ComSpec " /c `"" LGTV_CLI_PATH "`" -backlight 25",,"Hide"
}

; Menu+1 -> Set audio to DAC Headphones
#^!1::
{
  Run A_ComSpec " /c powershell Set-AudioDevice -ID $(python " GET_AUDIO_DEV_SCRIPT " -t dac)",,"Hide" ; DAC
  Run A_ComSpec " /c powershell Set-AudioDevice -ID $(python " GET_AUDIO_DEV_SCRIPT " -t mic)",,"Hide" ; Sennheiser mic
}

; Menu+2 -> Set audio to Speakers
#^!2::
{
  Run A_ComSpec " /c powershell Set-AudioDevice -ID $(python " GET_AUDIO_DEV_SCRIPT " -t sonos)",,"Hide" ; TV
  Run A_ComSpec " /c powershell Set-AudioDevice -ID $(python " GET_AUDIO_DEV_SCRIPT " -t mic)",,"Hide" ; Sennheiser mic
  Run A_ComSpec " /c C:\python\Scripts\sonos.exe `"Bedroom Speaker`" switch_to_tv",,"Hide"
}

; Menu+3 -> Set audio to Steelseries Arctis Nova Pro (Media)
#^!3::
{
  Run A_ComSpec " /c powershell Set-AudioDevice -ID $(python " GET_AUDIO_DEV_SCRIPT " -t arctis_media)",,"Hide" ; Media
  Run A_ComSpec " /c powershell Set-AudioDevice -ID $(python " GET_AUDIO_DEV_SCRIPT " -t arctis_mic)",,"Hide" ; Chat
}

; Menu+4 -> Set audio to Steelseries Arctis Nova Pro (Gaming)
#^!4::
{
  Run A_ComSpec " /c powershell Set-AudioDevice -ID $(python " GET_AUDIO_DEV_SCRIPT " -t arctis_gaming)",,"Hide" ; Gaming
  Run A_ComSpec " /c powershell Set-AudioDevice -ID $(python " GET_AUDIO_DEV_SCRIPT " -t arctis_mic)",,"Hide" ; Chat
}

; Menu+T -> Restart TV
#^!T::
{
  Run A_ComSpec " /c `"" LGTV_CLI_PATH "`" -poweroff",,"Hide"
  Sleep(1000)
  Run A_ComSpec " /c `"" LGTV_CLI_PATH "`" -poweron",,"Hide"
}

; Menu+Esc ->  Power Off TV
#^!esc::
{
  Run A_ComSpec " /c `"" LGTV_CLI_PATH "`" -poweroff",,"Hide"
}

; Super+Shift+Enter -> Opens Firefox
#+Enter::
{
    Run("firefox.exe")  ; Launch Firefox
    return
}

; Super+Enter -> Opens Windows Terminal
#Enter::
{
    Run("wt.exe")  ; Launch Windows Terminal
    return
}