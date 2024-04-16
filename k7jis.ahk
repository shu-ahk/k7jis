;@Ahk2Exe-SetMainIcon normal.ico

#Requires AutoHotkey v2.0
#SingleInstance Force

OnError MyErrorcallback

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

SendMode "InputThenPlay"

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

;https://edvakf.hatenadiary.org/entry/20101027/1288168554
SandS_SpaceDown := 0
SandS_SpaceDownTime := 0
;SandS_AnyKeyPressed := 0
hook := InputHook("L1 V,{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}")
*Space:: {
  global SandS_SpaceDown
  global SandS_SpaceDownTime
  ;global SandS_AnyKeyPressed

    ;TrayTip
    ;TrayTip "spaceDown", appName, 4+16+32
    ;SetTimer () => TrayTip(), -1000

  SendInput "{RShift Down}"
  If SandS_SpaceDown == 1
  {
    Return
  }
  SandS_SpaceDown := 1
  SandS_SpaceDownTime := A_TickCount ; milliseconds after computer is booted http://www.autohotkey.com/docs/Variables.htm
  ;SandS_AnyKeyPressed := 0
  ; watch for the next single key, http://www.autohotkey.com/docs/commands/Input.htm
  SandS_AnyKey := hook.Input
  ;SandS_AnyKeyPressed := 1
  Return
}

*Space Up:: {
  global SandS_SpaceDown
  global SandS_SpaceDownTime
  ;global SandS_AnyKeyPressed

    ;TrayTip
    ;TrayTip "spaceUp" . String(SandS_AnyKeyPressed), appName, 4+16+32
    ;SetTimer () => TrayTip(), -1000


  SendInput "{RShift Up}"
  SandS_SpaceDown := 0
  ;If SandS_AnyKeyPressed == 0 {
    If A_TickCount - SandS_SpaceDownTime < 200 {
      SendInput "{Space}"
    }
    ; Send EndKey of the "Input" command above
    ; You must use Send here since SendInput is ignored by "Input"
    Send "{RShift}"
  ;}
  Return
}

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

MyErrorcallback(Thrown, Mode)
{
    Reload
    return 1
}
