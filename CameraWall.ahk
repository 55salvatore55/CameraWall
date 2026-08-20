#Requires AutoHotkey v2.0
#SingleInstance Force

;==========================================================
; CameraWall
; Version 1.0.0
;
; Automatically opens, arranges and refreshes
; Windows Explorer windows used for camera monitoring.
;==========================================================

;---------------------------
; Modules
;---------------------------

#Include Source\Utils.ahk
#Include Source\Camera.ahk
#Include Source\Config.ahk
#Include Source\Explorer.ahk
#Include Source\Layout.ahk
#Include Source\Refresh.ahk


;---------------------------
; Main program
;---------------------------

Main()

return


Main()
{
    Log("===================================")
    Log("Starting CameraWall")
    Log("===================================")

    ;----------------------------------
    ; Load Config.ini
    ;----------------------------------

    if !LoadConfiguration()
    {
        ErrorMessage("Configuration loading error.")
        ExitApp
    }

    ;----------------------------------
    ; Load Layout.ini
    ;----------------------------------

    if !LoadLayout()
    {
        ErrorMessage("Layout loading error.")
        ExitApp
    }

    ;----------------------------------
    ; Open Explorer windows
    ;----------------------------------

    OpenExplorerWindows()

    Sleep 4000

    ;----------------------------------
    ; Apply layout
    ;----------------------------------

    ApplyLayout()

    Sleep 300

    ApplyLayout()

    Sleep 300

    BringAllToFront()

    ;----------------------------------
    ; Start refresh system
    ;----------------------------------

    InitializeRefresh()

    Log("CameraWall started successfully.")
}


;----------------------------------------------------------
; Save current layout
;----------------------------------------------------------

F9::
{
    SaveLayout()
    MsgBox("Layout saved.")
}