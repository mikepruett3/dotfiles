@ECHO OFF

REM Install package managers
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-WinGet.ps1"
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Scoop.ps1"
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Choco.ps1"

REM Install Sudo package
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Sudo.ps1"

REM refreshenv

PowerShell -File "%UserProfile%\.bootstrap\windows\ps1\Install-NerdFonts.ps1" -Name "Hack"
