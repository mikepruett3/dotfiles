@ECHO OFF

REM Install package managers
PowerShell -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-WinGet.ps1"' -Verb RunAs"
PowerShell -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Scoop.ps1"' -Verb RunAs"
PowerShell -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Choco.ps1"' -Verb RunAs"

REM Install Sudo package
REM PowerShell -NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Sudo.ps1" -Verb RunAs
PowerShell -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%UserProfile%\.bootstrap\windows\ps1\Install-Sudo.ps1"' -Verb RunAs"

REM refreshenv

REM PowerShell -File "%UserProfile%\.bootstrap\windows\ps1\Install-NerdFonts.ps1" -Name "Hack"
