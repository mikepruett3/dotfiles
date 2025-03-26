@ECHO OFF

REM Install package managers
PowerShell -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-WinGet.ps1"' -Verb RunAs -Wait"
PowerShell -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Scoop.ps1"' -Verb RunAs -Wait"
PowerShell -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Choco.ps1"' -Verb RunAs -Wait"

REM Install Sudo package
PowerShell -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Sudo.ps1"' -Verb RunAs -Wait"

REM refreshenv

PowerShell -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Packages.ps1" -Wait
PowerShell -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-NerdFonts.ps1" -Name "Hack" -Wait
