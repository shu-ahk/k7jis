;@Ahk2Exe-SetMainIcon normal.ico

#Requires AutoHotkey v2.0
#SingleInstance Force

DirCreate "icon"
FileInstall "normal.ico", "icon\normal.ico", true
FileInstall "f.ico", "icon\f.ico", true
TraySetIcon "icon\normal.ico"

; missing keys
; alt+ =+ -> \|
!^::\
!+^::|
; alt+ / -> _
!/::_
; ctrl+ / -> menu
^/::AppsKey

; Alt+Esc
fmode := false
!Esc::
{
    global fmode
    fmode := not fmode

    if fmode {
        TraySetIcon "icon\f.ico"
        msg := "F mode"
    } else {
        TraySetIcon "icon\normal.ico"
        msg := "Normal mode"
    }

    if CaretGetPos(&x, &y) {
        ToolTip msg, x, y + 20
    } else {
        ToolTip msg
    }
    SetTimer () => ToolTip(), -1000

}

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
!Up::PgUp
!Down::PgDn
!Left::Home
!Right::End
; ZenkakuHankaku
Esc::Send "{vkF3sc029}"
#hotif
