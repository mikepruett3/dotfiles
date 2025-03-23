@ECHO OFF

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "$HOME\.bootstrap\ps1\Install-Scoop.ps1 -Verbose"

PowerShell -Command "$HOME\.bootstrap\ps1\Install-NerdFonts.ps1 -Name Hack -Verbose"
