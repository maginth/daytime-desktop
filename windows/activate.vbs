' Script Activation/Deactivation

Dim objFSO, objShell, strShortcutPath, strScriptPath, objShortcut

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")

' Path to the startup folder
strShortcutPath = objShell.ExpandEnvironmentStrings("C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\hour_change_wallpaper.lnk")

' Path to the script you want to activate/deactivate
strScriptPath = objFSO.GetAbsolutePathName(".\hour_change_wallpaper.vbs")

' Check if the shortcut exists
If objFSO.FileExists(strShortcutPath) Then
    ' Deactivate the script by deleting the shortcut
    objFSO.DeleteFile strShortcutPath
    MsgBox "hour change wallpaper Activated." & vbCrLf &  "(Click again to deactivate)"
Else
    ' Activate the script by creating the shortcut
    Set objShortcut = objShell.CreateShortcut(strShortcutPath)
    objShortcut.TargetPath = strScriptPath
    objShortcut.Save
    MsgBox  "hour change wallpaper Deactivated." & vbCrLf &  "(Click again to activate)"
End If

Set objFSO = Nothing
Set objShell = Nothing