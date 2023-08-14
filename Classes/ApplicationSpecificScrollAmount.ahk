/*
    # Hotkey Definitions
*/

; Any non-specific window (Global).
#IfWinActive

; Extra Mouse Button to act as Scroll Lock. (Optional).
XButton2:: 
Send, {XButton2} ; Do not consume click. (Optional). 
    ApplicationSpecificScrollAmount.instance.ToggleScrollLock()
return

; Keeps track of the state of Scroll Lock. 
ScrollLock:: 
    ApplicationSpecificScrollAmount.instance.ToggleScrollLock()
return

; This is where the scrolling happens. 
WheelUp::ApplicationSpecificScrollAmount.instance.ChainCommand("{WheelUp}", ApplicationSpecificScrollAmount.instance._activeScrollAmount)
WheelDown::ApplicationSpecificScrollAmount.instance.ChainCommand("{WheelDown}", ApplicationSpecificScrollAmount.instance._activeScrollAmount)


class ApplicationSpecificScrollAmount
{
    ;############################################################################
    ;   Application-specific Scroll Amount, with Scroll Lock for more speed!!!  
    ;                 an AutoHotKey script made by Rovsau @ GitHub
    ;############################################################################

    ; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
    ; SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
    ; SetTitleMatchMode 2 ; Title Contains (Not really used by this script).
    ; Contains all the specific applications added down below.
    
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
    
    static instance

    __New(debug := true, path := "ApplicationSpecificScrollAmount.log")
    {
        ApplicationSpecificScrollAmount.instance := this
        /*
            # Debug Settings
        */
        this.debugToTextFile := debug
        this.debugLogFilePath := path
        this.Debug("ApplicationSpecificScrollAmount")
    
        /*
            # Initialize
        */
        ; Gets the current Toggle state of Scroll Lock (upon script start). 
        this._scrollLock := GetKeyState("ScrollLock", "T")
        
        this.apps := {}
        
        this._Global := [3, 9]
        
        this._currentActiveWindowTitle := ""
        this._activeScrollAmount := 3
        
        this.SetActiveScrollAmount(this._currentActiveWindowTitle)
    }

    Debug(message) {
        if (this.debugToTextFile) {
            path := this.debugLogFilePath
            FileAppend, %A_Now% - Scroller - %message%`n, %path%
        }
    }

    /*
        # Script Core
    */
    SetGlobalScrollSpeed(defaultSpeed, scrollLockSpeed) {
        this._Global := [defaultSpeed, scrollLockSpeed]
    }
    SetScrollSpeed(app, defaultSpeed, scrollLockSpeed) {
        this.apps[app] := [defaultSpeed, scrollLockSpeed]
    }

    OnWindowActivate(wintitle) {
        this.SetActiveScrollAmount(wintitle)
    }

    ; Updates current active window title, 
    ; and selects Scroll Amount based on Window Title and Scroll Lock On/Off. 
    SetActiveScrollAmount(wintitle)
    {
        this._currentActiveWindowTitle := wintitle
        for appName, scrollAmount in this.apps
        {
            if InStr(wintitle, appName)
            {
                this._activeScrollAmount := this._scrollLock ? scrollAmount[2] : scrollAmount[1]

                this.Debug("Matched App: <" appName "> Scroll Amount: <" this._activeScrollAmount ">")
                return
            }
        }
        ; if no match, use global
        this._activeScrollAmount := this._scrollLock ? this._Global[2] : this._Global[1]
        this.Debug("Using Global Value. Scroll Amount: <" this._activeScrollAmount ">")
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

    ; Keeps Scroll Lock in sync with the script, 
    ; and updates the scroll amount for the current active window (or global).
    ToggleScrollLock()
    {
        Send, {ScrollLock}
        this._scrollLock := !this._scrollLock
        this.SetActiveScrollAmount(this._currentActiveWindowTitle)
    }
}
; End of File.