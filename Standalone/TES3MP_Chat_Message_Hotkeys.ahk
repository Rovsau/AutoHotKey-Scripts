/*
    # TES3MP Chat Message Hotkeys, by Rovsau @ GitHub
*/
#Persistent  ; Keep the script running
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors. (Use for Debugging).
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;SetTitleMatchMode 2  ; Title Contains
;StringCaseSense, On  ; String-comparisons are case-sensitive. 

/*
    # Debug Settings
*/
global debugToTextFile := false
global debugLogFilePath := "TES3MP_Chat_Message_Hotkeys.log"
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

; Chat hotkey: 
global chat := "y"

#IfWinActive, TES3MP

F5::Chat("/s") 	; Storage
F6::Chat("/house") 	; Housing
F7::Chat("/furn") 	; Furnish
F8::Chat("/dh") 	; Decorate


Chat(message) {
	Send, %chat%
	Sleep, 1
	Send, %message%{Enter}
}

; Reload Script (CTRL + F12)
#IfWinActive ; Global
^F12:: ; CTRL,F12
Reload ; Reload this script with new changes
return
; End of File.
