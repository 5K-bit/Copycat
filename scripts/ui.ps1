# Dot-sourced by the launchers. Coloured banner and step/result lines.
# Docker's own output stays visible so long first builds show progress.

# Show-Banner: mascot (magenta) and wordmark (cyan -> blue) from kali\motd.
function Show-Banner {
    $lines = Get-Content (Join-Path (Split-Path $PSScriptRoot) 'kali\motd') -Encoding UTF8
    $grad = 'Cyan', 'Cyan', 'Blue', 'Blue', 'DarkBlue', 'DarkBlue'
    for ($i = 1; $i -le 3; $i++) { Write-Host $lines[$i] -ForegroundColor Magenta }
    for ($i = 5; $i -le 10; $i++) { Write-Host $lines[$i] -ForegroundColor $grad[$i - 5] }
}

# Invoke-Step LABEL SCRIPTBLOCK: runs the block, prints ok/FAIL, exits the script on failure.
function Invoke-Step([string]$Label, [scriptblock]$Block) {
    Write-Host ""
    Write-Host "==> $Label" -ForegroundColor Magenta
    & $Block
    if ($LASTEXITCODE -ne 0) {
        Write-Host "FAIL  $Label (exit $LASTEXITCODE)" -ForegroundColor Red
        exit $LASTEXITCODE
    }
    Write-Host " ok  $Label" -ForegroundColor Green
}
