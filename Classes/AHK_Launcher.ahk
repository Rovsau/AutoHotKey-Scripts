/*
    # AHK Launcher, by Rovsau @ Github
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
        FileAppend, %A_Now% - Launcher - %message%`n, %debugLogFilePath%
    }
}
FileOpen(debugLogFilePath, "w").Close() ; Clear log file on script start. 
Debug("---")
Debug("AHK_Launcher")

/*
    # Include classes without hotkey configurations anywhere. 
*/

#Include AHKiller.ahk
killer := new AHKiller(true, debugLogFilePath)
killer.Blacklist("Notepad")
killer.Whitelist("Notepad++")
killer.Whitelist(".mkv")
killer.Whitelist("Google Chrome")

scroller := new ApplicationSpecificScrollAmount(true, debugLogFilePath)
scroller.SetGlobalScrollSpeed(3, 9)
scroller.SetScrollSpeed("Discord", 3, 9)
scroller.SetScrollSpeed("Obsidian", 3, 9)
scroller.SetScrollSpeed("Visual Studio", 3, 9)
scroller.SetScrollSpeed("Visual Studio Code", 3, 9)
scroller.SetScrollSpeed("Notepad++", 3, 9)

#Include ShellMessageListener.ahk
shell := new ShellMessageListener(true, debugLogFilePath)
shell.AddListener(killer, killer.OnWindowActivate)
shell.AddListener(scroller, scroller.OnWindowActivate)



/*
    # Include classes with hotkey configurations at the bottom.
*/
#Include ApplicationSpecificScrollAmount.ahk
#Include ProgrammingHotkeys.ahk

; Reload Script (CTRL + F12)
#IfWinActive ; Global
^F12:: ; CTRL,F12
Reload ; Reload this script with new changes
return
; End of File.