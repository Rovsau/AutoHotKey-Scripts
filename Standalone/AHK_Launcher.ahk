/*
    # AHK Launcher

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
global debugLogFilePath := "AHK_Launcher.log"
Debug(message) {
    if (debugToTextFile) {
        FileAppend, %A_Now% - %message%`n, %debugLogFilePath%
    }
}
/*
    # Actions
*/
RunAHK("AHKiller.ahk")
RunAHK("ProgrammingHotKeys.ahk")
RunAHK("ApplicationSpecificScrollAmount.ahk")




/*
    # Script Core
*/
RunAHK(scriptPath) {
    Run, %A_AhkPath% %scriptPath%
}

/*
    # Developer
*/
; #IfWinActive ; Global
; ^F12:: ; CTRL,F12
; Reload ; Reload this script with new changes
; return
; End of File.