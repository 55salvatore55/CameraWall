#Requires AutoHotkey v2.0

;==========================================================
; CameraWall
; Layout.ahk
; Version 1.0.0
;==========================================================

global Layout := Map()


;----------------------------------------------------------
; Load Layout.ini
;----------------------------------------------------------
LoadLayout()
{
    global Layout
    global Cameras

    Layout := Map()

    LayoutFile := A_ScriptDir "\Layout.ini"

    if !FileExist(LayoutFile)
{
    Log("Layout.ini not found. Default layout will be used.")
    return true
}
    for Cam in Cameras
    {
        Section := "CAMERA" Cam.Id

        Item := Map()

        Item["X"] := IniRead(LayoutFile, Section, "X", 0) + 0
        Item["Y"] := IniRead(LayoutFile, Section, "Y", 0) + 0
        Item["W"] := IniRead(LayoutFile, Section, "W", 800) + 0
        Item["H"] := IniRead(LayoutFile, Section, "H", 600) + 0

        Layout[Cam.Id] := Item
    }

    Log("Layout loaded.")
    return true
}


;----------------------------------------------------------
; Save the current Explorer window layout
;----------------------------------------------------------
SaveLayout()
{
    global Cameras

    LayoutFile := A_ScriptDir "\Layout.ini"
    TempFile := LayoutFile ".tmp"
    SavedCount := 0

    ; Build the new layout in a temporary file.
    ; The existing Layout.ini is never deleted before the new file is ready.
    try
    {
        if FileExist(TempFile)
            FileDelete(TempFile)

        ; Preserve the existing layout so cameras that are temporarily
        ; unavailable are not lost during a save operation.
        if FileExist(LayoutFile)
            FileCopy(LayoutFile, TempFile, true)

        for Cam in Cameras
        {
            if (Cam.WindowHwnd = 0)
                continue

            if !WinExist("ahk_id " Cam.WindowHwnd)
                continue

            WinGetPos(&X, &Y, &W, &H, "ahk_id " Cam.WindowHwnd)

            Section := "CAMERA" Cam.Id

            IniWrite(X, TempFile, Section, "X")
            IniWrite(Y, TempFile, Section, "Y")
            IniWrite(W, TempFile, Section, "W")
            IniWrite(H, TempFile, Section, "H")

            SavedCount++

            Log("Layout saved: "
                Cam.Name
                " X=" X
                " Y=" Y
                " W=" W
                " H=" H)
        }

        ; Do not replace a valid layout with an empty file.
        if (SavedCount = 0 && !FileExist(LayoutFile))
        {
            FileDelete(TempFile)
            Log("Layout not saved: no valid Explorer windows.")
            return false
        }

        ; Replace the old layout only after the temporary file was written.
        FileMove(TempFile, LayoutFile, true)

        Log("Layout saved.")
        return true
    }
    catch
    {
        ; Keep the previous Layout.ini intact if anything fails.
        try
            if FileExist(TempFile)
                FileDelete(TempFile)

        Log("Layout save failed. Existing Layout.ini was preserved.")
        return false
    }
}


;----------------------------------------------------------
; Apply the layout to Explorer windows
;----------------------------------------------------------
ApplyLayout()
{
    global Cameras
    global Layout

    for Cam in Cameras
    {
        if (Cam.WindowHwnd = 0)
            continue

        if !Layout.Has(Cam.Id)
            continue

        Pos := Layout[Cam.Id]

        ; Keep the current window size
        WinGetPos(&CurX, &CurY, &CurW, &CurH, "ahk_id " Cam.WindowHwnd)

        WinMove(
            Pos["X"],
            Pos["Y"],
            Pos["W"],
            Pos["H"],
            "ahk_id " Cam.WindowHwnd
        )

        Log("Move "
            Cam.Name
            " HWND=" Cam.WindowHwnd
            " X=" Pos["X"]
            " Y=" Pos["Y"])
    }
}


;----------------------------------------------------------
; Bring all windows to the foreground
;----------------------------------------------------------
BringAllToFront()
{
    global Cameras

    for Cam in Cameras
    {
        if (Cam.WindowHwnd = 0)
            continue

        if !WinExist("ahk_id " Cam.WindowHwnd)
            continue

        try
        {
            WinActivate("ahk_id " Cam.WindowHwnd)
            Sleep 50
        }
    }
}


;----------------------------------------------------------
; Check that all windows are in the correct position
;----------------------------------------------------------
RefreshLayout()
{
    global Cameras
    global Layout

    for Cam in Cameras
    {
        if (Cam.WindowHwnd = 0)
            continue

        if !WinExist("ahk_id " Cam.WindowHwnd)
            continue

        if !Layout.Has(Cam.Id)
            continue

        Pos := Layout[Cam.Id]

        WinGetPos(&X, &Y, &CurW, &CurH, "ahk_id " Cam.WindowHwnd)

        if (X != Pos["X"] || Y != Pos["Y"])
        {
            WinMove(
                Pos["X"],
                Pos["Y"],
                CurW,
                CurH,
                "ahk_id " Cam.WindowHwnd
            )

            Log("Window repositioned: " Cam.Name)
        }
    }
}


;----------------------------------------------------------
; Restore all windows to their saved positions
;----------------------------------------------------------
RestoreLayout()
{
    ApplyLayout()

    BringAllToFront()

    Log("Layout restored.")
}