;@Ahk2Exe-SetMainIcon normal.ico

#Requires AutoHotkey v2.0
#SingleInstance Force

appName := "K7 JIS"

DirCreate "icon"
FileInstall "normal.ico", "icon\normal.ico", true
FileInstall "f.ico", "icon\f.ico", true
TraySetIcon "icon\normal.ico"

A_TrayMenu.Add
A_TrayMenu.Add "&Reload", MenuReload
A_TrayMenu.Add
A_TrayMenu.Add "&Toggle", MenuToggleFMode
A_TrayMenu.Default := "&Toggle"
A_TrayMenu.ClickCount := 1

SetTimer onTimer, 10*1000

; missing keys
; alt+^ -> \|
!^::\
!+^::|
; alt+/ -> _
!/::_
; ctrl+/ -> menu
^/::AppsKey

; alt+home->end
!Home::End
; alt+esc -> zenhan
LAlt & Esc::Send "{vkF3sc029}"

; alt+backspace
fmode := false
!BS::ToggleFMode()

~F & 1::F1

#hotif fmode
1::F1
2::F2
3::F3
4::F4
5::F5
6::F6
7::F7
8::F8
9::F9
0::F10
-::F11
^::F12
!1::1
!2::2
!3::3
!4::4
!5::5
!6::6
!7::7
!8::8
!9::9
!0::0
!-::-
!^::^
!Up::PgUp
!Down::PgDn
!Left::Home
!Right::End
#hotif

MenuToggleFMode(ItemName, ItemPos, MyMenu) 
{
    ToggleFMode
}

MenuReload(ItemName, ItemPos, MyMenu) 
{
    Reload
}

ToggleFMode()
{
    global fmode
    fmode := not fmode

    if fmode {
        icon := "icon\f.ico"
        msg := "Function mode"
    } else {
        icon := "icon\normal.ico"
        msg := "Normal mode"
    }

    TraySetIcon icon
    TrayTip
    TrayTip msg, appName, 4+16+32
    SetTimer () => TrayTip(), -3000
}

lastWindow := EnvGet("K7JIS_LASTWINDOW")
onTimer()
{
    win := String(WinActive("A"))
    global lastWindow

    if win != lastWindow {
        EnvSet("K7JIS_LASTWINDOW", win)
        Reload
    }
}
