$ShortcutPath = Join-Path ([Environment]::GetFolderPath("Startup")) "Fodhelper.lnk"
$Shell = New-Object -ComObject WScript.Shell
$Shortcut = $Shell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "C:\Windows\System32\fodhelper.exe"
$Shortcut.Save()
