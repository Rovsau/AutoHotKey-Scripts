# Classes

Script | Description
-|-
**AHK_Launcher** | is a global script which is used to initialize classes and utilize their functions.
**AHKiller** | listens for any Blacklisted app, or Fullscreen app that isn't Whitelisted, and terminates the script.  
**ApplicationSpecificScrollAmount** | (aka Scroller) listens for any app in its list, and applies corresponding Scroll Speed (number of lines).  
**ProgrammingHotkeys** | is an example of how hotkeys can be configured for improved workflow in specific applications.  
**ShellMessageListener** | is designed to add listeners, by passing a class instance and an 'instance.method', instead of a global function.   

# About
I created this because I like using AutoHotKey to improve my OS and Development workflow, and to have a neat way of terminating all the functionality upon a given condition.  
Specifically, I want to avoid triggering paranoid software, when I forget to close the scripts manually, before switching to games.  
I wasn't satisfied with scripting to close multiple scripts, as tests didn't seem reliable.  
So I converted some of the standalone scripts to classes, and worked out how to control everything from one script, and have that script simply close itself instead. 

**ShellMessageListener** is currently configured only to listen for Window Activations, passing the newly focused window's Title to the methods which subscribe to it.  
An improvement would be to make it react to multiple shell messages inside the switch, where it would trigger different events, which would require a restructure of how the script adds listeners.
