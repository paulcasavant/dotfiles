; Layout Screenshot on Laptop: 
;	1. Zoom in page as much as possible
;	2. Move cursor to x=58, y=901
;	Hold Alt to snap to preset size of 3270x1144

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

/*
	---Commands---
*/

; Google Selected Text
OpenHighlighted()
{
	MyClipboard := "" ; Clears variable

	Send, {ctrl down}c{ctrl up} ; More secure way to Copy things
	sleep, 50 ; Delay
	MyClipboard := RegexReplace( clipboard, "^\s+|\s+$" ) ; Trim additional spaces and line return
	sleep, 50
	MyStripped := RegexReplace(MyClipboard, " ", "") ; Removes every spaces in the string.
	
	StringLeft, OutputVarUrl, MyStripped, 8 ; Takes the 8 firsts characters
	StringLeft, OutputVarLocal, MyStripped, 3 ; Takes the 3 first characters
	sleep, 50
	
	if (OutputVarUrl == "http://" || OutputVarUrl == "https://")
	{
		; TrayTip,, URL: "%MyClipboard%"
		Sleep,50
		Run, "%MyStripped%"
		Return
	}
	else if (OutputVarLocal == "C:/" || OutputVarLocal == "C:\" || OutputVarLocal == "Z:/" || OutputVarLocal == "Z:\" || OutputVarLocal == "R:/" || OutputVarLocal == "R:\" ||)
	{
		; TrayTip,, Windows: "%MyClipboard%"
		Sleep,50
		Run, %MyClipboard%
		Return
	}
	else
	{
		; TrayTip,, GoogleSearch: "%MyClipboard%"
		Sleep,50
		Run, "http://www.google.com/search?q=%MyClipboard%"
		Return
	}
	Return
}

^!g::OpenHighlighted()

; Program Shortcuts
	#b::Run C:\Program Files (x86)\Google\Chrome\Application\chrome.exe ; Super+B -> Chrome [B]rowser
		KeyWait, b
		return

	#c::Run shortcuts\Calculator ; Super+C -> [C]alculator
		KeyWait, c
		return

	#e::Run C:\Windows\Excel ; Super+E -> [E]xcel
		KeyWait, e
		return

	#f::Run C:\Windows\explorer.exe ; Super+F -> [F]ile Explorer
		KeyWait, f
		return

	#m::Run shortcuts\Mail ; Super+M -> [M]ail
		KeyWait, m
		return

	#n::Run shortcuts\Notes ; Super+N -> [N]otes
		KeyWait, n
		return

	#o::Run shortcuts\OneNote ; Super+O -> [O]neNote
		KeyWait, o
		return

	#p::Run shortcuts\PowerPoint ; Super+P -> [P]owerPoint
		KeyWait, p
		return

	#s::Run shortcuts\Spotify ; Super+S -> [S]potify
	KeyWait, s
	return

	#t::Run shortcuts\Windows Terminal ; Super+T -> Fluent [T]erminal
		KeyWait, t
		return

	#v::Run shortcuts\Visual Studio Code
		KeyWait, v
		return

	#w::Run shortcuts\Word ; Super+W -> [W]ord
		KeyWait, w
		return

	#y::Run shortcuts\Your Phone ; Super+Y -> [Y]our Phone
		KeyWait, y
		return
		
	#z::Run shortcuts\Task Manager ; Super+Z -> Task Manager
		KeyWait, z
		return
		
	#,::Run shortcuts\Telegram ; Super+, -> Telegram
		KeyWait, `,
		return

	#.::Run https://messages.google.com/web/ ; Super+. -> Google Messages
		KeyWait, .
		return

; Alternate Arrow Key Window Snapping
	#i::Send, {Blind}#{Up}
	#k::Send, {Blind}#{Down}
	#j::Send, {Blind}#{Left}
	#l::Send, {Blind}#{Right}

; ShareX Shortcuts
	PrintScreen::Send, +!{1} ; PrintScreen -> Shift+Alt+1 (ShareX: Capture Region)
	#1::Send, +!{1} ; Super+1 -> Shift+Alt+1 (ShareX: Capture Region)
	#2::Send, +!{2} ; Super+2 -> Shift+Alt+2 (ShareX: Capture Entire Screen)
	#3::Send, +!{3} ; Super+3 -> Shift+Alt+3 (ShareX: Capture Active Window)
	#4::Send, +!{4} ; Super+4 -> Shift+Alt+4  (ShareX: Start/Stop Screen Recording)
	#5::Send, +!{5} ; Super+5 -> Shift+Alt+5 (ShareX: Start/Stop Screen Recording (GIF))

; Alternate Arrow Key Highlights
	^+s::Send, {Blind}^+{Left} ; Ctrl+Shift+S -> Highlight Left
	^+f::Send, {Blind}^+{Right} ; Ctrl+Shift+F -> Highlight Right
	^+e::Send, {Blind}^+{Up} ; Ctrl+Shift+E -> Highlight Up
	^+d::Send, {Blind}^+{Down} ; Ctrl+Shift+D -> Highlight Down

; Alternate Arrow Keys Switch Desktops
	^#j::Send, ^#{Left} ; Super+J -> Left Desktop
	^#l::Send, ^#{Right} ; Super+L -> Right Desktop

; Lock workstation
	#Esc:: ; Requires 2 'run as admin' registry writes. Using Task Scheduler to avoid UAC prompts.)
		RegRead, vIsDisabled, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation ; Enable 'lock workstation' (and enable Win+L hotkey)

		if vIsDisabled
			try RunWait, % "*RunAs " A_ComSpec " /c REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableLockWorkstation /t REG_DWORD /d 0 /f",, Hide ; Enable Win+L
			DllCall("user32\LockWorkStation") ; Lock Workstation:
			RegRead, vIsDisabled, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation ; Disable 'lock workstation' (and disable Win+L hotkey)
		
		if !vIsDisabled	
			try RunWait, % "*RunAs " A_ComSpec " /c REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableLockWorkstation /t REG_DWORD /d 1 /f",, Hide ; Disable Win+L
	return 

/*
	---Reference Code (Ignore)---
*/

; EXAMPLE: Adjust Display Scaling
	; #PgUp:: ; Requires 2 'run as admin' registry writes. Using Task Scheduler to avoid UAC prompts.)
	; 	RegWrite, REG_DWORD, HKEY_CURRENT_USER\Control Panel\Desktop, LogPixels, 288
	; 	RegWrite, REG_DWORD, HKEY_CURRENT_USER\Control Panel\Desktop, Win8DpiScaling, 1
	; 	Shutdown, 0
	; return

	; #PgDn:: ; Requires 2 'run as admin' registry writes. Using Task Scheduler to avoid UAC prompts.)
	; 	RegWrite, REG_DWORD, HKEY_CURRENT_USER\Control Panel\Desktop, LogPixels, 96
	; 	RegWrite, REG_DWORD, HKEY_CURRENT_USER\Control Panel\Desktop, Win8DpiScaling, 0
	; 	Shutdown, 0
	; return 

; EXAMPLE: Must double tap CapsLock to toggle CapsLock mode on or off.
	; CapsLock::
	; 	KeyWait, CapsLock                                                   ; Wait forever until Capslock is released.
	; 	KeyWait, CapsLock, D T0.2                                           ; ErrorLevel = 1 if CapsLock not down within 0.2 seconds.
	; 	if ((ErrorLevel = 0) && (A_PriorKey = "CapsLock") )                 ; Is a double tap on CapsLock?
	; 		{
	; 		SetCapsLockState, % GetKeyState("CapsLock","T") ? "Off" : "On"  ; Toggle the state of CapsLock LED
	; 		}
	; return

; /////////////////////////////////////////////////////////

; EXAMPLE: Using Non-Modifier Keys as Modifiers
; #::return
; # up::
; 	if (A_PriorKey = "Super")
; 		Send {Super}
; return

; # & i::Send {Up}
; # & j::Send {Left}
; # & k::Send {Down}
; # & l::Send {Right}

; /////////////////////////////////////////////////////////

; EXAMPLE: Toggle Bindings
; tog:=0 ; Start toggle in OFF state.

; Flips the toggle varible everytime the hotkey is pressed.
; F5::
; 	tog:=!tog
; 	KeyWait, F5
; 	tog:=!tog
; return

; ; Every hotkey binding below #if applies only when tog=1.
; #if tog=1
; CapsLock & F5::t ; Important to include CapsLock here if using as modifier.
; e::f
; r::p
; t::g
; y::j

; /////////////////////////////////////////////////////////

; EXAMPLE: Multitap
; CapsLock::
;  {
;    count++
;    settimer, actions, 175
;  }
; return

; actions:
;  {
;    if (count = 1)
;     {

;     }
;    else if (count = 2)
;     {
; 		msgbox, Double press.
;     }
;    else if (count = 3)
;     {
;       msgbox, Triple press.
;     }
;    count := 0
;  }
; return

; /////////////////////////////////////////////////////////

; EXAMPLE: Toggle CapsLock
; if GetKeyState("CapsLock", "T") = 1
; {
; SetCapsLockState, off
; }
; else if GetKeyState("CapsLock", "F") = 0
; {
; SetCapsLockState, on
; }

; /////////////////////////////////////////////////////////

; Must double tap CapsLock to toggle CapsLock mode on or off.
	; CapsLock::
	; 	KeyWait, CapsLock                                                   ; Wait forever until CapsLock is released.
	; 	KeyWait, CapsLock, D T0.2                                           ; ErrorLevel = 1 if CapsLock not down within 0.2 seconds.
	; 	if ((ErrorLevel = 0) && (A_PriorKey = ";") )                 ; Is a double tap on CapsLock?
	; 		{
	; 		Set;State, % GetKeyState(";","T") ? "Off" : "On"  ; Toggle the state of ; LED
	; 		}
	; return

; /////////////////////////////////////////////////////////
; EXAMPLE: Hide AutoHotKey Tray Icon
; #NoTrayIcon