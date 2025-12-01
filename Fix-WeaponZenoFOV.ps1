# Fix-WeaponZenoFOV.ps1
# Double-click ? press Enter twice ? FOV=90, zoom_FOV=80
# Or run with args: .\Fix-WeaponZenoFOV.ps1 100 75

param(
    [int]$DesiredFOV,
    [int]$DesiredZoomFOV
)

# Default values
$DefaultFOV     = 90
$DefaultZoomFOV = 80

# If no arguments given ? interactive prompt with defaults
if (-not $DesiredFOV -or -not $DesiredZoomFOV) {
    Write-Host "Default FOV     : $DefaultFOV"     -ForegroundColor Cyan
    Write-Host "Default zoom_FOV: $DefaultZoomFOV`n" -ForegroundColor Cyan

    $input = Read-Host "Enter desired FOV (or press Enter for $DefaultFOV)"
    $DesiredFOV = if ($input -match '^\d+$') { [int]$input } else { $DefaultFOV }

    $input = Read-Host "Enter desired zoom_FOV (or press Enter for $DefaultZoomFOV)"
    $DesiredZoomFOV = if ($input -match '^\d+$') { [int]$input } else { $DefaultZoomFOV }
}

Write-Host "`nUsing ? FOV = $DesiredFOV    |    zoom_FOV = $DesiredZoomFOV`n" -ForegroundColor Green

# === Rest of the script (unchanged, fully PS 5.1 compatible) ===
$ModRoot   = Split-Path -Parent $MyInvocation.MyCommand.Path
$TargetDir = Join-Path $ModRoot "zenozoik\scripts"

if (-not (Test-Path $TargetDir)) {
    Write-Host "ERROR: Folder not found: $TargetDir" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

$files = Get-ChildItem -LiteralPath $TargetDir -Filter "weapon_zeno*.txt" -File

if ($files.Count -eq 0) {
    Write-Host "No weapon_zeno*.txt files found." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit
}

foreach ($file in $files) {
    $path = $file.FullName
    $bak  = "$path.bak"

    if (-not (Test-Path $bak)) {
        Copy-Item $path $bak
        Write-Host "Backup: $($file.Name).bak" -ForegroundColor DarkGray
    }

    $content = Get-Content -Path $path -Raw
    $changed = $false

    if ($content -match '(?is)\bVisualData\s*\{([^}]*)\}') {
        $inside = $matches[1]

        if ($inside -match '\"FOV\"\s+\d+') {
            $content = $content -replace '\"FOV\"\s+\d+', "`"FOV`" $DesiredFOV"
            $changed = $true
        } else {
            $content = $content -replace '(\bVisualData\s*\{)', "`$1`r`n   `"FOV`" $DesiredFOV"
            $changed = $true
        }

        if ($inside -match '\"zoom_FOV\"\s+\d+') {
            $content = $content -replace '\"zoom_FOV\"\s+\d+', "`"zoom_FOV`" $DesiredZoomFOV"
            $changed = $true
        } else {
            $content = $content -replace '(\bVisualData\s*\{)', "`$1`r`n   `"zoom_FOV`" $DesiredZoomFOV"
            $changed = $true
        }

    } else {
        $newBlock = "`r`nVisualData`r`n{`r`n   `"FOV`" $DesiredFOV`r`n   `"zoom_FOV`" $DesiredZoomFOV`r`n}`r`n"
        $content += $newBlock
        $changed = $true
    }

    if ($changed) {
        $content = $content -replace "`r`n", "`n" -replace "`n", "`r`n"
        Set-Content -Path $path -Value $content -NoNewline
        Write-Host "UPDATED ? $($file.Name)" -ForegroundColor Green
    } else {
        Write-Host "No change ? $($file.Name)" -ForegroundColor Gray
    }
}

Write-Host "`nAll done! All weapon_zeno files now use FOV = $DesiredFOV and zoom_FOV = $DesiredZoomFOV" -ForegroundColor Cyan
Read-Host "Press Enter to close"