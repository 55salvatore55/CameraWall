#Requires AutoHotkey v2.0

;==========================================================
; CameraWall
; Refresh.ahk
; Version 1.0.0
;==========================================================

global LastDate := FormatTime(, "yyyy-MM-dd")


;----------------------------------------------------------
; Initialize the refresh system
;----------------------------------------------------------
InitializeRefresh()
{
    SetTimer(CheckDateChange, 600000)    ; Every 10 minutes

    Log("Refresh initialized.")
}


;----------------------------------------------------------
; Check for a date change
;
; Uncomment the diagnostic log below if troubleshooting
; is required.
;----------------------------------------------------------
CheckDateChange()
{
    ; Log("Entered CheckDateChange()")

    global LastDate

    ;------------------------------------------------------
    ; DATE CHANGE TEST
    ; Uncomment only to simulate midnight
    ;------------------------------------------------------

    ; Today := "2099-12-31"
    ; Log("*** DATE CHANGE TEST (simulated midnight) ***")

    Today := FormatTime(, "yyyy-MM-dd")

    ; No date change
    if (Today = LastDate)
    {
        CheckMissingWindows()
        return
    }


    ;------------------------------------------------------
    ; Open camera folders that have become available
    ;------------------------------------------------------
    CheckMissingWindows()
    {
        global Cameras

        Opened := false

        for Cam in Cameras
        {
            if CameraWindowAlive(Cam)
                continue

            if !CameraReady(Cam)
                continue

            Log("New folder found: " Cam.Name)

            if OpenSingleCamera(Cam)
                Opened := true
        }

        if Opened
        {
            Sleep 1000

            ApplyLayout()

            Sleep 300

            BringAllToFront()

            Log("Missing windows opened.")
        }
    }


    Log("========================================")
    Log("Date change detected")
    Log("Previous date: " LastDate)
    Log("New date     : " Today)
    Log("========================================")


    ;------------------------------------------------------
    ; Close all Explorer windows
    ;------------------------------------------------------

    CloseExplorerWindows()

    Sleep 1000


    ;------------------------------------------------------
    ; Reload the configuration
    ;------------------------------------------------------

    LoadConfiguration()


    ;------------------------------------------------------
    ; Reopen the Explorer windows
    ;------------------------------------------------------

    OpenExplorerWindows()

    Sleep 1500


    ;------------------------------------------------------
    ; Restore the layout
    ;------------------------------------------------------

    ApplyLayout()

    Sleep 300

    BringAllToFront()


    ; Update the date only after the refresh is complete
    LastDate := Today

    Log("Refresh completed.")
}