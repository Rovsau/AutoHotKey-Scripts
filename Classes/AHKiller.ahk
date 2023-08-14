/*
    # AHKiller
    Conditionally Terminates the main script.
    by Rovsau @ Github
*/
class AHKiller {
    
    __New(debug := false, path := "AHKiller.log")
    {
        /*
            # Debug Settings
        */
        this.debugToTextFile := debug
        this.debugLogFilePath := path
        this.Debug("AHKiller")
        
        /*
            # Initialize
        */
        ; Lists and index counters. 
        this._allowedList := {}
        this._allowedCount := 1
        this._deniedList := {}
        this._deniedCount := 1

        ; Keeps track of the current active window.
        ; this.RegisterToShellHook()


        /*
            # User Input
        */
        ; this.Blacklist("Notepad")
        ; this.Whitelist("Notepad++")

        ; this.Allow("Google Chrome", ".mkv")
    }


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
        # Script Core
    */
    Debug(message) {
        if (this.debugToTextFile) {
            path := this.debugLogFilePath
            FileAppend, %A_Now% - AHKiller - %message%`n, %path%
        }
    }

    Whitelist(params*) {
        this.Allow(params*)
    }

    Blacklist(params*) {
        this.Deny(params*)
    }

    Allow(params*) {
        for index, appName in params {
            this.Debug("Allow(" appName ")")
            this._allowedList[this._allowedCount++] := appName
        }
    }
    Deny(params*) {
        for index, appName in params {
            this.Debug("Deny(" appName ")")
            this._deniedList[this._deniedCount++] := appName
        }
    }

    OnWindowActivate(windowTitle) {
        this.Debug("OnWindowActivate() " windowTitle)

        if (this.IsDenied(windowTitle) and not this.IsAllowed(windowTitle)) {
            this.Debug(windowTitle " is Denied. AHK will terminate.")
            this.TerminateScript()
        }

        if (this.IsFullscreen(windowTitle)) {
            if (!this.IsAllowed(windowTitle)) {
                this.Debug(windowTitle " is Fullscreen. AHK will terminate.")
                this.TerminateScript()
            }
            else {
                this.Debug(windowTitle " is Fullscreen, and is Allowed.")
            }
        }
    }

    IsDenied(windowTitle) {
        for index, appName in this._deniedList {
            if (InStr(windowTitle, appName)) {
                this.Debug("Denied App: <" appName ">")
                return true
            }
        }
        return false
    }

    IsAllowed(windowTitle) {
        for index, appName in this._allowedList {
            if (InStr(windowTitle, appName)) {
                this.Debug("Allowed App: <" appName ">")
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

    TerminateScript() {
        ExitApp
    }

    ; Keeps track of the current active window.
    ; RegisterToShellHook() {
    ;     this.Debug("RegisterToShellHook()")
    ;     DllCall("RegisterShellHookWindow", UInt, A_ScriptHwnd)
    ;     this.MsgNum := DllCall("RegisterWindowMessage", Str, "SHELLHOOK")

    ;     ; Bind method to instance. 
    ;     this.method := this.ShellMessage.Bind(this)
    ;     OnMessage(this.MsgNum, this.method)
    ; }

    ; Delegate for ShellHook. Called by the global function AHKiller_ShellMessageHandler(wParam, lParam).
    ; ShellMessage(wParam, lParam) {
    ;     WinGetTitle, title, ahk_id %lParam%
    ;     switch (wParam) {
    ;         case 4, 0x8004:
    ;         ; 4 = HSHELL_WINDOWACTIVATED, 0x8004 = HSHELL_RUDEAPPACTIVATED (HSHELL_WINDOWACTIVATED | HSHELL_HIGHBIT)
    ;             this.OnWindowActivate(title)
    ;             ; Debug("ShellMessage: <" title ">")
    ;     }
    ; }
}
; End of File.