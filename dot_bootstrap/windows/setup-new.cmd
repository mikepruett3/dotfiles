@ECHO OFF

REM Install package managers
PowerShell -Wait -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-WinGet.ps1"' -Verb RunAs"
PowerShell -Wait -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Scoop.ps1"' -Verb RunAs"
PowerShell -Wait -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Choco.ps1"' -Verb RunAs"

REM Install Sudo package
PowerShell -Wait -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Sudo.ps1"' -Verb RunAs"

REM refreshenv

PowerShell -ExecutionPolicy Bypass -Wait -File "%UserProfile%\.bootstrap\windows\ps1\Install-Packages.ps1"
PowerShell -ExecutionPolicy Bypass -Wait -File "%UserProfile%\.bootstrap\windows\ps1\Install-NerdFonts.ps1" -Name "Hack"
