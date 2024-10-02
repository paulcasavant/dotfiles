#Requires AutoHotkey v2.0

; CapsLock -> Ctrl
CapsLock::Ctrl

; Ctrl+H/J/K/L -> Left/Down/Up/Right
^h::Send("{Left}")
^j::Send("{Down}")
^k::Send("{Up}")
^l::Send("{Right}")

; Ctrl+P -> Home
^p::Send("{Home}")

; Ctrl+; -> End
^`;::Send("{End}")

; Alt+C/A/V/P/X -> Ctrl+C/A/V/P/X
!c::Send("^c")
!a::Send("^a")
!v::Send("^v")
!p::Send("^p")
!x::Send("^x")

; Menu+Volume Down -> Set Sonos Relative Volume -1 
F13::Run A_ComSpec " /c C:\python\Scripts\sonos.exe `"Bedroom Speaker`" relative_volume -1",,"Hide"

; Menu+Volume Up -> Set Sonos Relative Volume +1 
F14::Run A_ComSpec " /c C:\python\Scripts\sonos.exe `"Bedroom Speaker`" relative_volume +1",,"Hide"

; Menu+RE Press -> Switch TV audio to TV
F15::Run A_ComSpec " /c C:\python\Scripts\sonos.exe `"Bedroom Speaker`" switch_to_tv",,"Hide"

; Menu+P -> Switch TV input to PC
#^!P::{
  Run A_ComSpec " /c `"C:\Program Files\LGTV Companion\LGTVcli.exe`" -poweron",,"Hide"
  Run A_ComSpec " /c `"C:\Program Files\LGTV Companion\LGTVcli.exe`" -sethdmi4",,"Hide"
}

; Menu+L -> Switch TV input to Laptop
#^!L::
{
  Run A_ComSpec " /c `"C:\Program Files\LGTV Companion\LGTVcli.exe`" -poweron",,"Hide"
  Run A_ComSpec " /c `"C:\Program Files\LGTV Companion\LGTVcli.exe`" -sethdmi3",,"Hide"
}

; Menu+F1 -> Switch to Desk Mode (125% scaling) with HDR
#^!F1::
{
  Run A_ComSpec " /c taskkill /IM Telegram.exe /F",,"Hide"
  Run A_ComSpec " /c `"C:\Program Files\DisplayFusion\DisplayFusionCommand.exe`" -monitorloadprofile Desk",,"Hide"
  ;Run A_ComSpec " /c C:\python\Scripts\sonos.exe `"Bedroom Speaker`" switch_to_tv",,"Hide"
  Sleep 2000
  Run A_ComSpec " /c C:\repos\windows-control\hdr.exe on",,"Hide"
  Run A_ComSpec " /c `"$HOME\AppData\Roaming\Telegram Desktop\Telegram.exe`" -scale 135 -startintray",,"Hide"
}

; Menu+F2 -> Switch Display to Desk Mode (125% scaling) without HDR
#^!F2::
{
  Run A_ComSpec " /c taskkill /IM Telegram.exe /F",,"Hide"
  Run A_ComSpec " /c `"C:\Program Files\DisplayFusion\DisplayFusionCommand.exe`" -monitorloadprofile Desk",,"Hide"
  ;Run A_ComSpec " /c C:\python\Scripts\sonos.exe `"Bedroom Speaker`" switch_to_tv",,"Hide"
  Sleep 2000
  Run A_ComSpec " /c C:\repos\windows-control\hdr.exe off",,"Hide"
  Run A_ComSpec " /c `"$HOME\AppData\Roaming\Telegram Desktop\Telegram.exe`" -scale 135 -startintray",,"Hide"
}

; Menu+F3 -> Switch Display to Recliner Mode (175% scaling) with HDR
#^!F3::
{
  Run A_ComSpec " /c taskkill /IM Telegram.exe /F",,"Hide"
  Run A_ComSpec " /c `"C:\Program Files\DisplayFusion\DisplayFusionCommand.exe`" -monitorloadprofile Recliner",,"Hide"
  ;Run A_ComSpec " /c C:\python\Scripts\sonos.exe `"Bedroom Speaker`" switch_to_tv",,"Hide"
  Sleep 2000
  Run A_ComSpec " /c C:\repos\windows-control\hdr.exe on",,"Hide"
  Run A_ComSpec " /c `"$HOME\AppData\Roaming\Telegram Desktop\Telegram.exe`" -scale 85 -startintray",,"Hide"
}

; Menu+F4 -> Switch Display to Recliner Mode (175% scaling) without HDR
#^!F4::
{
  Run A_ComSpec " /c taskkill /IM Telegram.exe /F",,"Hide"
  Run A_ComSpec " /c `"C:\Program Files\DisplayFusion\DisplayFusionCommand.exe`" -monitorloadprofile Recliner",,"Hide"
  ;Run A_ComSpec " /c C:\python\Scripts\sonos.exe `"Bedroom Speaker`" switch_to_tv",,"Hide"
  Sleep 2000
  Run A_ComSpec " /c C:\repos\windows-control\hdr.exe off",,"Hide"
  Run A_ComSpec " /c `"$HOME\AppData\Roaming\Telegram Desktop\Telegram.exe`" -scale 85 -startintray",,"Hide"
}

; Menu+. (>) -> Increase TV brightness by 10
#^!.::
{
  keywait "F13"
  Run A_ComSpec " /c python C:\repos\windows-control\set_brightness.py increase",,"Hide"
}

; Menu+, (<) -> Decrease TV relative brightness by 10
#^!,::
{
  keywait "F14"
  Run A_ComSpec " /c python C:\repos\windows-control\set_brightness.py decrease",,"Hide"
}

; Menu+/ -> Set TV brightness to maximum
#^!/::
{
  Run A_ComSpec " /c `"C:\Program Files\LGTV Companion\LGTVcli.exe`" -backlight 100",,"Hide"
}

; Menu+m -> Set TV brightness to low
#^!m::
{
  Run A_ComSpec " /c `"C:\Program Files\LGTV Companion\LGTVcli.exe`" -backlight 25",,"Hide"
}

; Menu+1 -> Switch audio to DAC Headphones
#^!1::
{
  Run A_ComSpec " /c powershell Set-AudioDevice -ID $(python c:\repos\windows-control\get_audio_id.py -t dac)",,"Hide" ; DAC
  Run A_ComSpec " /c powershell Set-AudioDevice -ID $(python c:\repos\windows-control\get_audio_id.py -t mic)",,"Hide" ; Sennheiser mic
}

; Menu+2 -> Switch audio to Speakers
#^!2::
{
  Run A_ComSpec " /c powershell Set-AudioDevice -ID $(python c:\repos\windows-control\get_audio_id.py -t sonos)",,"Hide" ; TV
  Run A_ComSpec " /c powershell Set-AudioDevice -ID $(python c:\repos\windows-control\get_audio_id.py -t mic)",,"Hide" ; Sennheiser mic
  Run A_ComSpec " /c C:\python\Scripts\sonos.exe `"Bedroom Speaker`" switch_to_tv",,"Hide"
}

; Menu+3 -> Switch audio to Steelseries Arctis Nova Pro (Media)
#^!3::
{
  Run A_ComSpec " /c powershell Set-AudioDevice -ID $(python c:\repos\windows-control\get_audio_id.py -t arctis_media)",,"Hide" ; Media
  Run A_ComSpec " /c powershell Set-AudioDevice -ID $(python c:\repos\windows-control\get_audio_id.py -t arctis_mic)",,"Hide" ; Chat
}

; Menu+4 -> Switch audio to Steelseries Arctis Nova Pro (Gaming)
#^!4::
{
  Run A_ComSpec " /c powershell Set-AudioDevice -ID $(python c:\repos\windows-control\get_audio_id.py -t arctis_gaming)",,"Hide" ; Gaming
  Run A_ComSpec " /c powershell Set-AudioDevice -ID $(python c:\repos\windows-control\get_audio_id.py -t arctis_mic)",,"Hide" ; Chat
}

; Menu+T -> Restart TV
#^!T::
{
  Run A_ComSpec " /c `"C:\Program Files\LGTV Companion\LGTVcli.exe`" -poweroff",,"Hide"
  Sleep(1000)
  Run A_ComSpec " /c `"C:\Program Files\LGTV Companion\LGTVcli.exe`" -poweron",,"Hide"
}

; Menu+Esc ->  Power Off TV
#^!esc::
{
  Run A_ComSpec " /c `"C:\Program Files\LGTV Companion\LGTVcli.exe`" -poweroff",,"Hide"
}