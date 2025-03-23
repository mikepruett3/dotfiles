@ECHO OFF

PowerShell -NoProfile -ExecutionPolicy Bypass -File "$HOME\.bootstrap\windows\ps1\Install-Scoop.ps1 -Verbose"

PowerShell -File "$HOME\.bootstrap\windows\ps1\Install-NerdFonts.ps1 -Name Hack -Verbose"
