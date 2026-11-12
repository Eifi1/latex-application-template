# Builds the PDFs with XeLaTeX from MiKTeX. Nothing else is needed (no Perl, no latexmk).
#
#   .\build.ps1               builds every .tex file in this folder
#   .\build.ps1 lebenslauf    builds only lebenslauf.tex
#
# Windows blocks .ps1 scripts by default ("running scripts is disabled on this system").
# Start it with build.cmd instead (double-click, or .\build.cmd in PowerShell), or like this:
#   powershell -ExecutionPolicy Bypass -File .\build.ps1

param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Documents
)

Set-Location -LiteralPath $PSScriptRoot

# Started by right-click ("Run with PowerShell")? Then keep the window open at the end.
$startedFromExplorer = [Environment]::GetCommandLineArgs() -contains '-Command'

function Stop-Build([int]$code) {
    if ($startedFromExplorer) { Read-Host 'Press Enter to close' | Out-Null }
    exit $code
}

# --- find xelatex ---------------------------------------------------------------
$xelatex = $null
$command = Get-Command xelatex -ErrorAction SilentlyContinue
if ($command) {
    $xelatex = $command.Path
} else {
    # a fresh MiKTeX installation is not on the PATH of windows that were already open
    $candidates = @()
    if ($env:LOCALAPPDATA) { $candidates += Join-Path $env:LOCALAPPDATA 'Programs\MiKTeX\miktex\bin\x64\xelatex.exe' }
    if ($env:ProgramFiles) { $candidates += Join-Path $env:ProgramFiles 'MiKTeX\miktex\bin\x64\xelatex.exe' }
    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) { $xelatex = $candidate; break }
    }
}
if (-not $xelatex) {
    Write-Host 'xelatex was not found. Install MiKTeX from https://miktex.org/download,'
    Write-Host 'open a new PowerShell window and run this script again.'
    Stop-Build 1
}

$texArgs = @('-interaction=nonstopmode', '-halt-on-error')
$versionLine = & $xelatex --version | Select-Object -First 1
if ("$versionLine" -match 'MiKTeX') {
    # MiKTeX downloads missing packages by itself instead of asking for each one
    $texArgs += '--enable-installer'
    Write-Host 'Note: the first build downloads missing packages and can take several minutes.'
}

# --- which documents ------------------------------------------------------------
if ($Documents) {
    $names = $Documents | ForEach-Object { [IO.Path]::GetFileNameWithoutExtension($_) }
} else {
    $names = Get-ChildItem -Filter '*.tex' | Sort-Object Name | ForEach-Object { $_.BaseName }
}

function Get-AuxHash([string]$path) {
    if (Test-Path -LiteralPath $path) { return (Get-FileHash -LiteralPath $path).Hash }
    return ''
}

# --- build ----------------------------------------------------------------------
$failed = @()
foreach ($name in $names) {
    if (-not (Test-Path -LiteralPath "$name.tex")) {
        Write-Host "$name.tex not found"
        $failed += $name
        continue
    }
    Write-Host "Building $name.pdf ..."
    $ok = $true
    # LaTeX needs at least two runs for page numbers; repeat until the .aux file is stable
    for ($run = 1; $run -le 4; $run++) {
        $before = Get-AuxHash "$name.aux"
        & $xelatex @texArgs "$name.tex" | Out-Null
        if ($LASTEXITCODE -ne 0) { $ok = $false; break }
        if ($run -ge 2 -and $before -eq (Get-AuxHash "$name.aux")) { break }
    }
    if ($ok -and (Test-Path -LiteralPath "$name.pdf")) {
        Remove-Item -LiteralPath "$name.aux", "$name.out", "$name.log" -ErrorAction SilentlyContinue
        Write-Host "  done: $name.pdf"
        continue
    }
    $failed += $name
    Write-Host "  FAILED: $name.tex"
    if (Test-Path -LiteralPath "$name.log") {
        $log = Get-Content -LiteralPath "$name.log" -Encoding UTF8
        if ($log -match "I can't write on file") {
            Write-Host "  $name.pdf is open in another program. Close it and run the script again."
        } else {
            # show the first error with the lines that follow it (they contain the line number)
            for ($i = 0; $i -lt $log.Count; $i++) {
                if ($log[$i].StartsWith('!')) {
                    $log[$i..([Math]::Min($i + 2, $log.Count - 1))] | ForEach-Object { Write-Host "  $_" }
                    break
                }
            }
            Write-Host "  Full details: $name.log"
        }
    }
}

if ($failed.Count -gt 0) { Stop-Build 1 }
Stop-Build 0
