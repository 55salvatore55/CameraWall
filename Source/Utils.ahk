#Requires AutoHotkey v2.0

;==========================================================
; CameraWall
; Utils.ahk
; Version 1.0.0
;==========================================================

global LogFile := A_ScriptDir "\..\CameraWall.log"


;----------------------------------------------------------
; Write a line to the log file
;----------------------------------------------------------
Log(Text)
{
    global LogFile

    TimeStamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")

    try
        FileAppend(TimeStamp " - " Text "`n", LogFile, "UTF-8")
}


;----------------------------------------------------------
; Check whether a folder exists
;----------------------------------------------------------
FolderExists(Path)
{
    return DirExist(Path) != ""
}


;----------------------------------------------------------
; Check whether a file exists
;----------------------------------------------------------
FileExistsEx(Path)
{
    return FileExist(Path) != ""
}


;----------------------------------------------------------
; Return the current date in YYYY-MM-DD format
;----------------------------------------------------------
GetTodayFolder()
{
    return FormatTime(, "yyyy-MM-dd")
}


;----------------------------------------------------------
; Return the name of the most recently modified JPG
;----------------------------------------------------------
GetLastJpg(Path)
{
    if !DirExist(Path)
        return ""

    LastFile := ""
    LastTime := ""

    Loop Files Path "\*.jpg", "F"
    {
        if (LastFile = "" || A_LoopFileTimeModified > LastTime)
        {
            LastFile := A_LoopFileName
            LastTime := A_LoopFileTimeModified
        }
    }

    return LastFile
}


;----------------------------------------------------------
; Display an error message
;----------------------------------------------------------
ErrorMessage(Text)
{
    Log("ERROR: " Text)

    MsgBox(
        Text,
        "CameraWall",
        "Iconx"
    )
}