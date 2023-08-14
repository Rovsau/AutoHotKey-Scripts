/*
    # AHKiller
    Conditionally Terminates All AutoHotKey scripts.
    by Rovsau @ Github

    Script Initialization
*/
#Persistent  ; Keep the script running
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors. (Use for Debugging).
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode 2  ; Title Contains (Not really used by this script).
StringCaseSense, On  ; String-comparisons are case-sensitive. 
global _allowedList := {}
global _allowedCount = 1
global _deniedList := {}
global _deniedCount = 1

/*
    # Debug Settings
*/
global debugToTextFile := true
global debugLogFilePath := "AHKiller.log"
/*
    # ReadMe

    This script will terminate all AHK instances (ungracefully) when conditions are met. 
    Focusing a Fullscreen application will trigger termination, unless the app has been added to the Allowed list by the user.
    Non-fullscreen applications can also trigger termination, if the app has been added to the Denied list by the user. 
    The initial purpose of the script is to avoid running AHK scripts while running applications which may be paranoid of such scripts. 

    Blacklist() and Whitelist() store a string of text in the Denied/Allowed lists. 
    If this string is CONTAINED within a Window Title which comes into focus, termination will either be triggered or avoided. 

    If an app is found to be Fullscreen or Denied, the script will also check if the app is found in the Allowed list. 
    This ensures that ambiguity can be solved by using both Blacklist() and Whitelist(). 
    

    # Example
    
    Blacklist("Notepad")
    Whitelist("Notepad++")

    # Limitations

    If an application is already focused before it is Fullscreen, 
    this script will not detect that, 
    until another app has been focused, and the fullscreen app is focused again. 

*/



/*
    # User Input
*/
Blacklist("Notepad")
Whitelist("Notepad++")

Allow("Google Chrome", ".mkv")



/*
    # Script Core
*/
Debug(message) {
    if (debugToTextFile) {
        FileAppend, %A_Now% - %message%`n, %debugLogFilePath%
    }
}

Whitelist(params*) {
    Allow(params*)
}

Blacklist(params*) {
    Deny(params*)
}

Allow(params*) {
    for index, appName in params {
        _allowedList[_allowedCount++] := appName
    }
}
Deny(params*) {
    for index, appName in params {
        _deniedList[_deniedCount++] := appName
    }
}

OnWindowActivate(windowTitle) {
    Debug("------------------------")
    Debug(windowTitle)

    if (IsDenied(windowTitle) and not IsAllowed(windowTitle)) {
        Debug(windowTitle " is Denied. AHK will terminate.")
        TerminateAHK()
    }

    if (IsFullscreen(windowTitle)) {
        if (!IsAllowed(windowTitle)) {
            Debug(windowTitle " is Fullscreen. AHK will terminate.")
            TerminateAHK()
        }
        else {
            Debug(windowTitle " is Fullscreen, and is Allowed.")
        }
    }
}

IsDenied(windowTitle) {
    for index, appName in _deniedList {
        if (InStr(windowTitle, appName)) {
            Debug("Denied App: <" appName "> in Window Title: <" windowTitle ">")
            return true
        }
    }
    return false
}

IsAllowed(windowTitle) {
    for index, appName in _allowedList {
        if (InStr(windowTitle, appName)) {
            Debug("Allowed App: <" appName "> in Window Title: <" windowTitle ">")
            return true
        }
    }
    return false
}

IsFullscreen(windowTitle) {
    winID := WinExist(windowTitle)
    if (!winID) {
        return false
    }
    WinGet style, Style, ahk_id %winID%
    WinGetPos ,,,winW,winH, %windowTitle%
    return ((style & 0x20800000) or winH < A_ScreenHeight or winW < A_ScreenWidth) ? false : true
}

TerminateAHK() {
    ; List of all AHK executables to be terminated
    ahkExecutables := ["AutoHotkey.exe", "AutoHotkeyA32.exe", "AutoHotkeyU32.exe", "AutoHotkeyU64.exe", "AutoHotkey32.exe", "AutoHotkey64.exe", "AutoHotkeyUX.exe", "AutoHotkey32_UIA.exe", "AutoHotkey64_UIA.exe"]
    
    ; Get the Process ID of this script to avoid terminating itself prematurely
    thisProcessId := DllCall("GetCurrentProcessId", "UInt")
    
    ; Loop through and terminate each AHK process excluding the current script
    for index, exeName in ahkExecutables {
        pid := ProcessExist(exeName) ; get the process ID
        While pid && (pid != thisProcessId) {
            Process, Close, %pid%
            pid := ProcessExist(exeName) ; check again if the process is still running
        }
    }
    
    ; Allow the log file to be appended (somehow..)
    ExitApp ; Close the script itself
}

ProcessExist(exeName) {
    Process, Exist, %exeName%
    return ErrorLevel ; Returns the process ID if the process exists, otherwise 0
}

; Keeps track of the current active window.
DllCall("RegisterShellHookWindow", UInt, A_ScriptHwnd)
MsgNum := DllCall("RegisterWindowMessage", Str, "SHELLHOOK")
OnMessage(MsgNum, "ShellMessage")

; Delegate for ShellHook. 
ShellMessage(wParam, lParam) {
    WinGetTitle, title, ahk_id %lParam%
    switch (wParam) {
        case 4, 0x8004:
        ; 4 = HSHELL_WINDOWACTIVATED, 0x8004 = HSHELL_RUDEAPPACTIVATED (HSHELL_WINDOWACTIVATED | HSHELL_HIGHBIT)
            OnWindowActivate(title)
            ; Debug("ShellMessage: <" title ">")
    }
}
; End of File.