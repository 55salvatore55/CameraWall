#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

;===========================================================
; CameraWall
; Versione : 0.1.0
; Autore   : Salvatore + ChatGPT
;===========================================================

global AppName := "CameraWall"
global Version := "0.1.0"

SetWorkingDir(A_ScriptDir)

#Include Source\Config.ahk
#Include Source\Explorer.ahk
#Include Source\Layout.ahk
#Include Source\Refresh.ahk
#Include Source\Utils.ahk

Main()

return

Main()
{
    try
    {
        Log("===================================")
        Log(AppName " " Version)
        Log("Avvio programma")

        if !LoadConfiguration()
        {
            MsgBox "Errore durante il caricamento della configurazione."
            ExitApp
        }

        CameraList := GetCameraList()

        if CameraList.Length = 0
        {
            MsgBox "Nessuna telecamera configurata."
            ExitApp
        }

        Log("Telecamere configurate: " CameraList.Length)

        OpenExplorerWindows(CameraList)

        ArrangeExplorerWindows()

        StartRefreshTimer()

        Log("CameraWall avviato correttamente.")
    }
    catch Error as Err
    {
        MsgBox
        (
            "Errore:`n`n"
            Err.Message
            "`nRiga: " Err.Line
        )

        Log("ERRORE: " Err.Message)
    }
}