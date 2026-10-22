Set-Location (Split-Path $PSScriptRoot)
. "$PSScriptRoot\ui.ps1"
Invoke-Step 'Stopping Copycat (your changes are kept)' { docker compose stop }
