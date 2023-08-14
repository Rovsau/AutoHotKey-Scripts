/*
    # Programming Hot Keys

    Script Initialization
*/
#Persistent  ; Keep the script running
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors. (Use for Debugging).
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode 2  ; Title Contains (Not really used by this script).
StringCaseSense, On  ; String-comparisons are case-sensitive. 
/*
    # Debug Settings
*/
global debugToTextFile := true
global debugLogFilePath := "ProgrammingHotKeys.log"
Debug(message) {
    if (debugToTextFile) {
        FileAppend, %A_Now% - %message%`n, %debugLogFilePath%
    }
}
/*
    # Actions
*/


/*
    # Script Core
*/
; Concatenates multiple messages into a single Send call. 
; Mix strings and commands.
SendMessage(params*) {
    message := ""
    for index, item in params {
        message .= item
    }
    Send, % message
}
; a = UnityEngine.Debug.Log(`$`"{{}{}}`");
; b = {Left}{Left}{Left}{Left}
; SendMessage(a, b)

/*
    # Hotkeys

    CTRL    ^
    SHIFT   +
    ALT     !
    Win/CMD #

    Variant modifiers   < > 

    Left CTRL   <^
    Right CTRL  >^

    AltGr   <^>!
*/


#IfWinActive, Visual Studio Code

; CTRL + K + D  ::  SHIFT + ALT + F

; # Most promising solution: 
; #If A_PriorHotkey = "~^k" && A_TimeSincePriorHotkey < 1500
; ~^d::
; Debug("abc")
; ; Send, +!f
; #If


; isCtrlKPressed := false
; ~^k::
;     isCtrlKPressed := true
;     SetTimer, ResetCtrlK, -500 ; After 500ms, reset the state
; return
; ~^d::
;     if (isCtrlKPressed) {
;         Send, +!f
;         isCtrlKPressed := false
;     } else {
;         Send, d
;     }
; return
; ResetCtrlK:
;     isCtrlKPressed := false
; return


; ^k:: ; CTRL + K
; KeyWait, K
; Input, key, L1 T0.5
; if (key = "d") {
;     Send, +!f
; }
; return

; ^m:: ; CTRL + M
; KeyWait, M
; Input, key, L1 T0.5
; if (key = "o") {
;     Send, ^k1
;     Debug("yay")
; }
; return

#IfWinActive, Visual Studio

:*:getset::{Text}{ get; private set; }

+insert:: ; Shift + Insert
Send, [SerializeField]{Space}
return

^|:: ; CTRL + Pipe
Send, {Text}UnityEngine.Debug.Log();
Send, {Left}{Left}
return

#|:: ; Win + Pipe
Send, {Text}UnityEngine.Debug.Log($"{}");
Send, {Left}{Left}{Left}{Left}
return


/*
    # Developer
*/
#IfWinActive ; Global
^F12:: ; CTRL,F12
Reload ; Reload this script with new changes
return
; End of File.