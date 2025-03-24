@ECHO OFF

REM Install package managers
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-WinGet.ps1" -Verbose
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Scoop.ps1" -Verbose
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Choco.ps1" -Verbose

REM Install Sudo package
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Sudo.ps1" -Verbose

REM refreshenv

PowerShell -File "%UserProfile%\.bootstrap\windows\ps1\Install-NerdFonts.ps1" -Name "Hack" -Verbose
