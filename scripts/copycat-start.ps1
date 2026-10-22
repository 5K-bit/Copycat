# Start (and build if needed) the Copycat lab.
Set-Location (Split-Path $PSScriptRoot)
. "$PSScriptRoot\ui.ps1"
Show-Banner
Invoke-Step 'Building and starting Copycat' { docker compose up -d --build }
Write-Host "`nConnect:  ssh copycat@127.0.0.1 -p 2222   (password: copycat)" -ForegroundColor DarkGray
