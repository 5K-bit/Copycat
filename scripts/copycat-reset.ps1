# Destroy the Copycat lab and recreate it from the images.
# Only touches the "copycat" compose project (copycat-kali, copycat-target, copycat-net).
# Use -Rebuild to also rebuild the images from scratch.
param([switch]$Rebuild)
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot)
docker compose down --volumes --remove-orphans
if ($Rebuild) { docker compose build --no-cache }
docker compose up -d --build --force-recreate
Write-Host @'

   /\_/\   ___
  ( o.o ) |   |   <- the cup is back on the table.
   > ^ <  |___|
'@ -ForegroundColor Magenta
Write-Host "Copycat is clean.  ssh copycat@127.0.0.1 -p 2222   (password: copycat)"
