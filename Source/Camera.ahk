#Requires AutoHotkey v2.0

;==========================================================
; CameraWall
; Camera.ahk
; Version 1.0.0
;==========================================================

class Camera
{
    __New(Id, Name, BasePath, SubFolder)
    {
        this.Id := Id
        this.Name := Name

        ; Fixed base path configured in Config.ini
        this.BasePath := RTrim(BasePath, "\")

        ; Example: 01\pic
        this.SubFolder := Trim(SubFolder)

        ; Full path for the current day
        this.Path := ""

        ; Last image found
        this.LastImage := ""

        ; Explorer window handle
        this.WindowHwnd := 0

        ; Camera status
        this.Online := false

        ; Last check
        this.LastCheck := ""

        ; Window coordinates
        this.X := 0
        this.Y := 0
        this.Width := 0
        this.Height := 0

        ; Build the current day's path immediately
        this.UpdateTodayPath()
    }

    ;------------------------------------------------------
    ; Update the path using the current date
    ;------------------------------------------------------
    UpdateTodayPath()
    {
        Today := GetTodayFolder()

        this.Path := this.BasePath "\" Today "\" this.SubFolder
    }

    ;------------------------------------------------------
    ; Check whether the folder exists
    ;------------------------------------------------------
    Exists()
    {
        return DirExist(this.Path) != ""
    }

    ;------------------------------------------------------
    ; Find the latest JPG image
    ;------------------------------------------------------
    UpdateLastImage()
    {
        this.LastImage := GetLastJpg(this.Path)

        if (this.LastImage != "")
            this.Online := true
        else
            this.Online := false

        this.LastCheck := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    }

    ;------------------------------------------------------
    ; Return the full path of the latest image
    ;------------------------------------------------------
    GetImageFile()
    {
        if (this.LastImage = "")
            return ""

        return this.Path "\" this.LastImage
    }

    ;------------------------------------------------------
    ; Return the display name
    ;------------------------------------------------------
    ToString()
    {
        return this.Name
    }
}