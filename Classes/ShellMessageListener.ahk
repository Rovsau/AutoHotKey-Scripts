/*
    # Shell Message Listener, by Rovsau @ Github
*/
class ShellMessageListener {

    Debug(message) {
        if (this.debugToTextFile) {
            path := this.debugLogFilePath
            FileAppend, %A_Now% - ShellMessageListener - %message%`n, %path%
        }
    }
    
    __New(debug := true, path := "ShellMessageListener.log") {
        
        /*
            # Debug Settings
        */
        this.debugToTextFile := debug
        this.debugLogFilePath := path
        this.Debug("New")
    
        ; Register Window.
        DllCall("RegisterShellHookWindow", Ptr, A_ScriptHwnd)
    
        ; Listen for Shell Messages.
        this.MsgNum := DllCall("RegisterWindowMessage", Str, "SHELLHOOK")
    
        ; Bind this instance to the function object.
        this.method := this.OnShellMessage.Bind(this)

        ; Subscribe listener function. 
        OnMessage(this.MsgNum, this.method)
    
        ; Contain listeners.
        this.listeners := {}
        this.listenersCount := 1
    }

    ; Used by main script.
    AddListener(listener, method) {
        this.listeners[listener] := method
    }

    OnShellMessage(wParam, lParam) {
        switch (wParam) {
            ; 4 = HSHELL_WINDOWACTIVATED, 0x8004 = HSHELL_RUDEAPPACTIVATED (HSHELL_WINDOWACTIVATED | HSHELL_HIGHBIT)
            case 4, 0x8004:
            WinGetTitle, windowTitle, ahk_id %lParam%
            this.NotifyListeners(windowTitle)
        }
    }

    NotifyListeners(windowTitle) {
        this.Debug("NotifyListeners: " windowTitle)
        for listener, method in this.listeners {
            method.Call(listener, windowTitle)
        }
    }
}