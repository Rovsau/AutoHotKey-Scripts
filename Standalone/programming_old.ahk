#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetTitleMatchMode 2 ; Title Contains


Class ClipChange{
    static funO := ClipChange._setup()
    _setup(){
        this.freq := (freq, DllCall("QueryPerformanceFrequency", "Int64*", freq))
        return, ((hmm := this.onClipChange.Bind(this)), OnClipboardChange(hmm, -1))
    }
    onClipChange(type){
        this.time := (time, DllCall("QueryPerformanceCounter", "Int64*", time))
        this.cState := type
    }
    wait(timeout := 0, type := -1){
        while((type < 0 ? true : type == this.type) && this.time > (now, DllCall("QueryPerformanceCounter", "Int64*", now)))
            if((now - this.time) / this.freq > timeout)
                return
    }
}



#IfWinActive, Visual Studio

; <Custom Scroll Lock>
; MButton, ScrollLock, WheelUp, WheelDown

scrollHorizontal := false ; Default 

MButton::
Send, {MButton}
Send, {ScrollLock}
scrollHorizontal := !scrollHorizontal ; Toggle
return

ScrollLock::
Send, {ScrollLock}
scrollHorizontal := !scrollHorizontal ; Toggle
return

WheelUp::
if (customScrollLock)
{
	Send, {WheelUp}{WheelUp}{WheelUp}{WheelUp}{WheelUp}{WheelUp}{WheelUp}{WheelUp}
}
else
{
	Send, {WheelUp}
}
return

WheelDown::
if (customScrollLock)
{
	Send, {WheelDown}{WheelDown}{WheelDown}{WheelDown}{WheelDown}{WheelDown}{WheelDown}{WheelDown}
}
else
{
	Send, {WheelDown}
}
return
; </Custom Scroll Lock>



:*:getset::{Text}{ get; private set; }
;Send, {Esc}{{} get{Esc}; private set{Esc}; {}}
;return

::to array::
LastClip := ClipboardAll
Send, {Backspace}
Send, ^+{Left}
Clipboard := ""
Send, ^x
ClipWait
Send, %Clipboard%[] myArrayName = new %Clipboard%[] {{}{}}{Text};
Send, ^{Left}^{Left}^{Left}^{Left}^{Left}^{Left}^{Left}^{Left}{Left}^+{Left}
Clipboard := LastClip
return

::to list::
LastClip := ClipboardAll
Send, {Backspace}
Send, ^+{Left}
Clipboard := ""
Send, ^x
ClipWait
Send, List<%Clipboard%> myListName = new List<%Clipboard%>{Text}();
Send, ^{Left}^{Left}^{Left}^{Left}^{Left}^{Left}^{Left}^{Left}^{Left}{Left}^+{Left}
Clipboard := LastClip
return

::_to_property::
LastClip := ClipboardAll
Send, {Backspace}
Send, ^+{Left}
Clipboard := ""
Send, ^x
ClipWait

Send, private %Clipboard% myProperty{Text};
Send, {Enter}
Send, public %Clipboard% MyProperty {{}}
Send, {Enter}
Send, get{Esc} {Text}{ return myProperty; }
Send, {Enter}
Send, set{Esc} {Text}{ myProperty = value; }

Clipboard := LastClip
return

<^>!p:: ; AltGr P
^r::
;LastClip := ClipboardAll
;Send, ^c
;ClipWait
;ClipChange.wait()
myCopy := Clipboard
myArray := StrSplit(myCopy, A_Space, ";")
datatype := myArray[1]
propertyName := myArray[2]

Send, {Home}{Enter}{Up}
Send, % "public " datatype " _" propertyName
Send, {{}}
Send, {Enter}
Send, get{Esc} {Text}{ return
Send, % " " propertyName
Send, {Text}; }
Send, {Enter}
Send, set{Esc} {Text}{ 
Send, % propertyName " = value" 
Send, {Esc}{Text};}

;Clipboard := LastClip
return

+insert::
Send, [SerializeField]{Space}
return

^insert::
Send, private static void Placeholder() {{}}
Send, {Enter}
Send, {Up}{Up}^{Right}^{Right}^+{Right}
return

#insert::
Send, public static void Placeholder() {{}}
Send, {Enter}
Send, {Up}{Up}^{Right}^{Right}^+{Right}
return

#|::
Send, {Text}UnityEngine.Debug.Log($"{}");
Send, {Left}{Left}{Left}{Left}
return


#IfWinActive ; Global

^F12:: ; CTRL,F12
Reload ; Reload this script with new changes
return

^F11:: ; CTRL,F11
Send, !{Space}x ; Maximize Active Window
return

^F10:: ; CTRL,F11
Send, !{Space}r ; Restore Active Window
return



