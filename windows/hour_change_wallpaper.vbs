prev_wallpaper = ""
prev_theme = -1

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
scriptFolder = objFSO.GetParentFolderName(WScript.ScriptFullName)


Do While True
	Set current_hour_wallpapers = CreateObject("System.Collections.ArrayList")
	current_hour_wallpapers.Add ""

	Set folder = objFSO.GetFolder(scriptFolder)

	h = Hour(now)
	closest_h = -1

	For Each file in folder.Files
		file_prefix = Mid(file.name, 1, 2)
		If isNumeric(file_prefix) Then
			file_h = CInt(file_prefix)
			If file_h > closest_h And file_h <= h Then
				closest_h = file_h
				current_hour_wallpapers(0) = file.Path
			ElseIf file_h = h Then
				current_hour_wallpapers.Add file.Path
			End If
		End If
	Next

	wallpaper = current_hour_wallpapers.Item(Minute(now)*current_hour_wallpapers.Count \ 60)
	theme = -(h > 6 And h < 20)

	If prev_theme <> theme Then
		key_prefix = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize\"
		objShell.RegWrite key_prefix & "\AppsUseLightTheme", theme
		objShell.RegWrite key_prefix & "\SystemUsesLightTheme", theme
		prev_theme = theme
	End If

	If prev_wallpaper <> wallpaper Then
		objShell.Run "powershell -c $code = @'" & vbCrLf & _
		"using System.Runtime.InteropServices;" & _
		"namespace Win32{ public class Wallpaper{" & _
			"[DllImport(""""""user32.dll"""""", CharSet=CharSet.Auto)]" & _
			"static extern int SystemParametersInfo (int uAction , int uParam , string lpvParam , int fuWinIni);" & _
			"public static void SetWallpaper(string thePath){" & _
				"SystemParametersInfo(20,0,thePath,3);" & _
			"}}}" & vbCrLf & _
		"'@" & vbCrLf & _
		"add-type $code" & vbCrLf & _
		"[Win32.Wallpaper]::SetWallpaper(""""""" & wallpaper & """"""")", 0
		objFSO.CopyFile wallpaper, scriptFolder & "\wallpaper.jpg", True 'for other applications
		prev_wallpaper = wallpaper
	End If

	WScript.Sleep 60000

Loop
