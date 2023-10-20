/*
    TES3MP Macros & Hotkeys, by Rovsau @ GitHub
*/
#Persistent  ; Keep the script running
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors. (Use for Debugging).
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;SetTitleMatchMode 2  ; Title Contains
;StringCaseSense, On  ; String-comparisons are case-sensitive. 
CoordMode, Mouse, Relative  ; https://www.autohotkey.com/docs/v1/lib/CoordMode.htm

/*
    Debug Settings
*/
global debugToTextFile := true
global debugLogFilePath := "TES3MP_Macros_&_Hotkeys.log"
Debug(message) {
    if (debugToTextFile) {
        FileAppend, %A_Now% - %message%`n, %debugLogFilePath%
    }
}
if (debugToTextFile) {
    FileOpen(debugLogFilePath, "w").Close() ; Clear log file on script start. 
}
Debug("Script start")

/*
	Hotkey Modifiers
	
	CTRL    ^
	SHIFT   +
	ALT     !
	Win/CMD #
	
	Variant modifiers   < > 
	
	Left CTRL   <^
	Right CTRL  >^
	
	AltGr   <^>!
*/

; In-game open chat hotkey
global chat := "y"

^F12::Reload ; Reload Script (CTRL + F12)
OnExit("RestoreInput")
#IfWinActive, ahk_exe tes3mp.exe

F5::Chat("/s") 	; Storage
F6::Chat("/house") 	; Housing
F7::Chat("/furn") 	; Furnishing
F8::Chat("/dh") 	; Decorate
F9::Chat("/who")	; Online Players
F10::Chat("/warplist")

!Numpad0::Warp("balmora")
!Numpad1::Warp("seydaneen")
!Numpad2::Warp("aldruhn")
!Numpad3::Warp("vivec")
!Numpad4::Warp("telbranora")
!Numpad5::Warp("telmora")
!Numpad6::Warp("telfyr")
!Numpad7::Warp("molagmar")
!Numpad8::Warp("solstheim") ; not working
!Numpad9::Warp("mournhold")

; CTRL modifier
^MButton::ChainSellToRestockingNPC(37) ; times
; Alt modifier
!MButton::TradeMany(40) ; times
!LButton::MoveToStorage(100) ; points from right
!RButton::MoveToInventory(450) ; points from left

DisableInput() {
	BlockInput, On
	BlockInput, MouseMove
	Debug("Input Disabled")
}

RestoreInput() {
	BlockInput, Off
	BlockInput, MouseMoveOff
	Debug("Input Restored")
}

ChainSellToRestockingNPC(times) {
	if not GetKeyState("ScrollLock", "T") {
		return 
	}
	Debug("ChainSellToRestockingNPC")
	DisableInput()
	
	loop %times% {
		Send, {CtrlDown}{Click}{CtrlUp}
		Sleep, 10
		Send, {Space}
		Sleep, 10
		Send, {Space}
		Sleep, 200
	}
	
	RestoreInput()
}

MoveToStorage(pointsFromRight) {
	if not GetKeyState("ScrollLock", "T") {
		return
	}
	Debug("MoveToStorage")
	DisableInput()
	
	SysGet, MaxX, 0
	SysGet, MaxY, 1
	MouseGetPos, MouseX, MouseY
	newX := MaxX - pointsFromRight
	newY := MouseY
	Send, {ShiftDown}{Click}{Click %newX% %newY%}{Click %MouseX% %MouseY% 0}{ShiftUp}
	
	RestoreInput()
}

MoveToInventory(pointsFromLeft) {
	if not GetKeyState("ScrollLock", "T")
		return 
	Debug("MoveToInventory")
	DisableInput()
	
	MouseGetPos, MouseX, MouseY
	newX := pointsFromLeft
	newY := MouseY
	Send, {ShiftDown}{Click}{Click %newX% %newY%}{Click %MouseX% %MouseY% 0}{ShiftUp}
	
	RestoreInput()
}

TradeMany(times) {
	if not GetKeyState("ScrollLock", "T")
		return 
	Debug("TradeMany")
	DisableInput()
	
	loop %times% {
		Send, {ShiftDown}{Click}
	}
	Send, {ShiftUp}
	
	RestoreInput()
}

Chat(message) {
	if not GetKeyState("ScrollLock", "T") {
		return 
	}
	; Debug(message)
	DisableInput()
	
	Send, %chat%
	Sleep, 10
	Send, %message%
	Sleep, 10
	Send, {Enter}
	
	RestoreInput()
}

Warp(message) {
	if not GetKeyState("ScrollLock", "T") {
		return 
	}
	; Debug(message)
	DisableInput()
	
	warp := "/warp " message
	Debug(warp)
	Send, %chat%
	Sleep, 10
	Send, %warp%{Enter}
	
	RestoreInput()
}
; End of File.
