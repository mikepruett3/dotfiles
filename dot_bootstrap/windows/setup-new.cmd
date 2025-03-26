@ECHO OFF

REM Install package managers, if missing
PowerShell -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-WinGet.ps1"' -Verb RunAs" -Wait
PowerShell -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Choco.ps1"' -Verb RunAs" -Wait
PowerShell -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Scoop.ps1"

REM Install Sudo package, if missing
PowerShell -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Sudo.ps1"' -Verb RunAs" -Wait

REM Install required packages, if missing
PowerShell -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Packages.ps1"' -Verb RunAs" -Wait

REM Installing Nerd Fonts, if missing
PowerShell -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-NerdFonts.ps1" -Name "Hack"

REM Set the Execution Policy
PowerShell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"

REFRESHENV
