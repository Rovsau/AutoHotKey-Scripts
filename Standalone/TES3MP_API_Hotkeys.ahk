/*
    # TES3MP API Hotkeys, by Rovsau @ Github
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
global debugToTextFile := true
global debugLogFilePath := "Morrowind.log"
Debug(message) {
    if (debugToTextFile) {
        FileAppend, %A_Now% - %message%`n, %debugLogFilePath%
    }
}
if (debugToTextFile) {
    FileOpen(debugLogFilePath, "w").Close() ; Clear log file on script start. 
}
Debug("Script start")

; Chat hotkey: 
global chat := "y" 

#IfWinActive, TES3MP

F5::Command("/s")
F6::Command("/housing")
F7::Command("/furn")
F8::Command("/dh")

Command(command) {
	Send, %chat%
	Sleep, 1
	Send, %command%{Enter}
}

; Reload Script (CTRL + F12)
#IfWinActive ; Global
^F12:: ; CTRL,F12
Reload ; Reload this script with new changes
return
; End of File.