;############################################################################
;   Application-specific Scroll Amount, with Scroll Lock for more speed!!!  
;                 an AutoHotKey script made by Rovsau @ GitHub
;############################################################################

#Persistent ; Keep the script running
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors. (Use for Debugging).
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode 2 ; Title Contains (Not really used by this script).
; Contains all the specific applications added down below.
global apps := Object()

; 
; 
; ### About 
; 
; 	This script enables Application-specific Scroll Amount, 
; 	with support for Scroll Lock to enable two modes for scrolling, per application. 
; 
; 	Uses the following mouse and keyboard inputs: 
; 	Mouse: 		WheelUp, WheelDown, XButton2 (Extra button)
; 	Keyboard: 	ScrollLock
; 
; 
; ### How to use script: 
; 
; # Define scroll amount for specific applications
;   (In order to match, the Name must be contained within the app Window Title)
; 
; 	Syntax:		apps["AppName"] := [Default, ScrollLock]
; 	Example: 	apps["Visual Studio"] =: [3, 6]
; 
; # Add applications to the list below: (apps)
;
;   For apps with similar names, like Notepad++ and Notepad, 
;   the longest or most unique name should be on top, allowing all matches to be found.
;
; 
; ### Global Scroll Amount 
; 
; 	Applies for any application not specified in the list.
; 
; # Set Global Scroll Amount in the array below: (_Global)
; 
; 	Syntax:		[Default, ScrollLock]
; 	Example: 	[3, 8]
; 



;<UserInput>
apps["Discord"] := [3,9]
apps["Obsidian"] := [3, 1]
apps["Visual Studio Code"] := [3, 9]
apps["Visual Studio"] := [3, 9]
apps["Notepad++"] := [3, 9]
apps["Notepad"] := [3, 9]
;</UserInput>


;<UserInput>
global _Global := [3, 9]
;</UserInput>

; ### Enable/Disable Debug Tooltips.
; <UserInput>
global debugTooltips := false
; </UserInput>




; 
; ### Debugging
; 
; Sleep duration affects how soon a new action can be executed.
ShowTooltip(message)
{
    Tooltip, % message
    Sleep, 2000
    Tooltip
}

; 
; ### Script Core 
; 

global _currentActiveWindowTitle := ""
global _activeScrollAmount := 3

; Updates current active window title, 
; and selects Scroll Amount based on Window Title and Scroll Lock On/Off. 
SetActiveScrollAmount(wintitle)
{
    _currentActiveWindowTitle := wintitle
    for appName, scrollAmount in apps
    {
        if InStr(wintitle, appName)
        {
            _activeScrollAmount := _scrollLock ? scrollAmount[2] : scrollAmount[1]

            if (debugTooltips)
            {
                ShowTooltip("Matched App: <" appName "> `nScroll Amount: <" _activeScrollAmount "> `nwintitle: <" wintitle ">")
            }
            return
        }
    }
    ; if no match, use global
    _activeScrollAmount := _scrollLock ? _Global[2] : _Global[1]
    if (debugTooltips)
    {
        ShowTooltip("Using Global Value.`nScroll Amount: <" _activeScrollAmount ">`nwintitle: <" wintitle ">")
    }
}

; Keeps track of the current active window.
DllCall("RegisterShellHookWindow", UInt, A_ScriptHwnd)
MsgNum := DllCall("RegisterWindowMessage", Str, "SHELLHOOK")
OnMessage(MsgNum, "ShellMessage")

; Delegate for ShellHook. 
ShellMessage(wParam, lParam)
{
    WinGetTitle, title, ahk_id %lParam%
    switch (wParam)
    {
        case 4, 0x8004:
        ; 4 = HSHELL_WINDOWACTIVATED, 0x8004 = HSHELL_RUDEAPPACTIVATED (HSHELL_WINDOWACTIVATED | HSHELL_HIGHBIT)
            SetActiveScrollAmount(title)
            ; ShowTooltip("ShellMessage: <" title ">")
    }
}

; Send a command many times with a single Send message. 
ChainCommand(command, times) 
{
	chain := ""
	Loop, %times%
	{
		chain .= command
	}
	Send, % chain
}

; Gets the current Toggle state of Scroll Lock (upon script start). 
global _scrollLock := GetKeyState("ScrollLock", "T")

; Keeps Scroll Lock in sync with the script, 
; and updates the scroll amount for the current active window (or global).
ToggleScrollLock()
{
    Send, {ScrollLock}
    _scrollLock := !_scrollLock
    SetActiveScrollAmount(_currentActiveWindowTitle)
}

; Initialize scroll amount based on active window (upon script start).
SetActiveScrollAmount(_currentActiveWindowTitle)

; Any non-specific window (Global).
#IfWinActive

; Extra Mouse Button to act as Scroll Lock. (Optional).
XButton2:: 
Send, {XButton2} ; Do not consume click. (Optional). 
	ToggleScrollLock()
return

; Keeps track of the state of Scroll Lock. 
ScrollLock:: 
	ToggleScrollLock()
return

; This is where the scrolling happens. 
WheelUp::ChainCommand("{WheelUp}", _activeScrollAmount)
WheelDown::ChainCommand("{WheelDown}", _activeScrollAmount)
; End of File.