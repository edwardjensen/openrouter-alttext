param(
    [Parameter(Mandatory = $true)]
    [string]$ImagePath
)

# Convert the image to a base64 string
$base64Image = [Convert]::ToBase64String([IO.File]::ReadAllBytes($ImagePath))

# Get the file extension and determine the MIME type
$extension = [System.IO.Path]::GetExtension($ImagePath).ToLower()
$contentType = switch ($extension) {
    ".jpg"  { "image/jpeg" }
    ".jpeg" { "image/jpeg" }
    ".png"  { "image/png" }
    ".gif"  { "image/gif" }
    ".webp" { "image/webp" }
    ".svg"  { "image/svg+xml" }
    default { "application/octet-stream" }
}

# Format the base64 string with content-type prefix
$base64ImageWithPrefix = "data:$contentType;base64,$base64Image"

# Save the formatted base64 string
$base64ImageWithPrefix | Out-File -FilePath "base64-image.txt"

$OpenRouterAPIKey = security find-generic-password -s "openrouter-api-key" -a "openrouter-api-key" -w
$OpenRouterModel = "anthropic/claude-3.7-sonnet"

$InstructionString = "You write alt text for any image pasted in by the user. Alt text is always presented in a fenced code block to make it easy to copy and paste out. It is always presented on a single line so it can be used easily in Markdown images. All text on the image (for screenshots etc) must be exactly included. A short note describing the nature of the image itself should go first. Any quotation marks or other punctuation needs to be cancelled out."

$RequestHeaders = @{
    "Content-Type" = "application/json"
    "Authorization" = "Bearer $OpenRouterAPIKey"
}
$RequestBody = @{
    "model" = $OpenRouterModel
    "messages" = @(
        @{
            "role" = "user"
            "content" = @(
                @{
                    "type" = "text"
                    "text" = $InstructionString
                }
                @{
                    "type" = "image_url"
                    "image_url" = @{
                        "url" = $base64ImageWithPrefix
                    }
                }
            )
        }
    )
}

# Convert the hashtable to JSON before sending
$RequestBodyJson = $RequestBody | ConvertTo-Json -Depth 10

# Send the request with the JSON body
$response = Invoke-RestMethod -Method Post -Uri https://openrouter.ai/api/v1/chat/completions -Headers $RequestHeaders -Body $RequestBodyJson

# Extract the alt text from the response
$AltText = $response.choices[0].message.content

# Output the alt text
$AltText
$AltText | pbcopy