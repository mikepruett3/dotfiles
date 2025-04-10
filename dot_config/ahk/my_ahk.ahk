#NoEnv                     ; Recommended for performance and compatibility with future AutoHotKey releases.
#SingleInstance Force      ; Starts all Included AutoHotKey Scripts as one - https://stackoverflow.com/questions/4565321/autohotkey-calling-one-script-from-another-script
;#Warn                     ; Enable warnings to assist with detecting common errors.
SendMode, Input            ; Recommended for new scripts due to its superior speed and reliability.

;========== Include Custom AutoHotKey Script ==========
#Include, %A_WorkingDir%\Custom\Custom.ahk

;========== Globally Available Functions ==========
GetIP(URL){
    http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
    http.Open("GET",URL,1)
    http.Send()
    http.WaitForResponse
    If (http.ResponseText="Error"){
        MsgBox 16, IP Address, Sorry, your public IP address could not be detected
        Return
    }
    return http.ResponseText
}

RemoveToolTip:
ToolTip
Return

;========== Globally Available Hotkeys ==========
; Reload AutoHotkey Hotkey (CTRL + R)
^R::
Run %ComSpec% /c ""chezmoi.exe" "update",, Hide
SplashTextOn,100,50,AutoHotKeySystem,`nReloading...
Sleep, 500
Reload
SplashTextOff
Return

; Show Public IP Address Hotkey (CTRL + SHIFT + I)
^+I::
clipboard := GetIP("ifconfig.co/")
MsgBox 64, IP Address, Your Public IP Address is: %Clipboard%
Return


; Temporarily Suspend AutoHotkey Hotkey (WIN + ScrollLock)
; https://www.maketecheasier.com/favorite-autohotkey-scripts/
#ScrollLock::
SplashTextOn,200,50,AutoHotKeySystem,`nSuspending Hotkeys...
Sleep, 500
Suspend
SplashTextOff
Return

; Empty Recycle Bin Hotkey (WIN + Delete)
; https://www.maketecheasier.com/favorite-autohotkey-scripts/
#Del::
SplashTextOn,200,50,AutoHotKeySystem,`nEmptying Trash...
Sleep, 500
FileRecycleEmpty
SplashTextOff
Return

; ========== Hotkeys that work in everything except explorer.exe ==========
#IfWinNotActive, ahk_exe explorer.exe
    ; Text Replacement Hotkeys
    :*:omw::
    SendInput, On My Way{!}
    SendInput, {Space}
    Return

    ;:*:btw::
    ;SendInput, By the way,
    ;SendInput, {Space}
    ;Return

    ;:*:ty::
    ;SendInput, Thank You
    ;SendInput, {Space}
    ;Return

    ;:*:np::
    ;SendInput, No Problem
    ;SendInput, {Space}
    ;Return

    :*:hk::
    SendInput, Hotkey
    SendInput, {Space}
    Return

    :*:kk::
    SendInput, ok
    SendInput, {Space}
    Return

    :*:tt::
    FormatTime, Time,, Time
    SendInput, %Time%
    SendInput, {Space}
    Return

    :*:dd::
    FormatTime, Date,, ShortDate
    SendInput, %Date%
    SendInput, {Space}
    Return

    :*:tst::
    FormatTime, TimeStamp,, dd-MMM-yyyy-HH-mm-ss
    SendInput, %TimeStamp%
    SendInput, {Space}
    Return

    ::asshole::
    asshole()
    Return

    ::safeharbor::
    safeharbor()
    Return
#IfWinNotActive

; ========== Hotkeys that only work in Obsidian.exe ==========
#IfWinActive, ahk_exe Obsidian.exe
    :*:dte::
    FormatTime, Date,, ShortDate
    SendInput, {#}{#} %Date%
    SendInput, {Enter}
    Return
#IfWinActive

; ========== Hotkeys that only work in explorer.exe ==========
#IfWinActive, ahk_exe explorer.exe
    ; New Text File Hotkey (CTRL + SHIFT + T)
    ^+t::
    Path := GetActiveExplorerPath()
    NoFile = 0
    Loop
    {
        IfExist, %Path%\NewTextFile%NoFile%.txt
        {
            NoFile++
        } Else {
            Break
        }
    }
    FileAppend, ,%Path%\NewTextFile%NoFile%.txt
    Return

    ; Show and Hide Hidden Files Hotkey (.)
    .::
    ToggleHiddenFilesDisplay()
    Return

;    ; Move Up a Folder in File Explorer Hotkey (BackSpace)
;    ; https://www.maketecheasier.com/favorite-autohotkey-scripts/
;    BackSpace::
;    Send, !{Up}
;    Return
#IfWinActive

; ---------- Archive ----------

;========== Run MouseJiggler AutoHotKey Script ==========
;DetectHiddenWindows, On
;IfWinNotExist, %A_WorkingDir%\Scripts\MouseJiggler.ahk
;{
;    Run, %A_WorkingDir%\Scripts\MouseJiggler.ahk
;}
;DetectHiddenWindows, Off

;SystemType := GetChassisType()
;RunOnSystems := "Portable Laptop Notebook Handheld DockingStation All-in-One Sub-Notebook LunchBox"
;If InStr(RunOnSystems, SystemType)
;{
;    Run, %A_WorkingDir%\Scripts\MouseJiggler.ahk
;}

;========== MacOS "Command-M"-like Hotkey ==========
; Lifted from RamValli's post - https://stackoverflow.com/questions/42918534/autohotkey-script-to-toggle-minimize-maximize-window
; WIN + M
;#M::
;WinGet, WindowID, ID, A
;WinGet, WindowStatus, MinMax, ahk_id %WindowID%
;WinMinimize, ahk_id %WindowID%
;DetectHiddenWindows, On
;If (!WindowID)
;{
;    WinGet, WindowID, ID, A
;} Else {
;    MinMaxWindow(WindowID)
;}
;Return

;========== MacOS "Command-Q"-like Hotkey ==========
; WIN + Q
;#Q::
;WinGet, WindowID, ID, A
;WinGet, WindowStatus, MinMax, ahk_id %WindowID%
;WinClose, ahk_id %WindowID%
;Return

;========== TextOnlyPaste Hotkey ==========
; CTRL + SHIFT + V
;^+V::
;TextOnlyPaste()
;Return

;========== Hide/Show Taskbar Hotkey ==========
; CTRL + SHIFT + F12
;^+F12::
;HideShowTaskbar(hide := !hide)
;Return

;========== Transparency toggle, Scroll Lock ==========
; https://www.reddit.com/r/AutoHotkey/comments/lvzqlx/share_your_most_useful_ahk_scripts_my_huge/
;sc046::
;toggle:=!toggle
;If toggle=1
;{
;    WinSet, Transparent, 150, A
;} Else {
;    WinSet, Transparent, OFF, A
;}
;Return
