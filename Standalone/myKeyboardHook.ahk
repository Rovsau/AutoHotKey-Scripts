#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#InstallKeybdHook

SetTitleMatchMode 2 ; Title Contains



#IfWinActive ; Global

^F12:: ; CTRL,F12
Reload ; Reload this script with new changes
return



^F1:: ; ctrl
KeyHistory
return

^F11:: ; ctrl
MsgBox, % GetKeyName("vk179")
return

; sc164		F13

; 319, 440

vk440::
MsgBox, Key Clicked
return