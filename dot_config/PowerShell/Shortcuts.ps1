$Shell = New-Object -ComObject WScript.Shell

# Setup AutoHotKey environment auto-start on login
$Shortcut = Join-Path -Path (Resolve-Path $Shell.SpecialFolders("startup")) -ChildPath "My AHK.lnk"
if (-not (Test-Path -Path $Shortcut)) {
    Create-Shortcut -Link $Shortcut `
    -App "$ENV:UserProfile\.config\ahk\my_ahk.ahk" `
    -Icon "$ENV:ProgramFiles\AutoHotkey\AutoHotkey.exe, 1" `
    -Description "My AutoHotKey Launcher"
}
Remove-Variable -Name Shortcut -ErrorAction SilentlyContinue

# Create Windows Key Manager Shortcut in Programs
$Shortcut = Join-Path -Path (Resolve-Path $Shell.SpecialFolders("programs")) -ChildPath "Key Manager.lnk"
if (-not (Test-Path -Path $Shortcut)) {
    Create-Shortcut -Link $Shortcut `
    -App "$ENV:SystemRoot\System32\rundll32.exe" `
    -Arguments "keymgr.dll,KRShowKeyMgr" `
    -Icon "$ENV:SystemRoot\System32\imageres.dll, 77" `
    -Description "Windows Key Manager"
}
Remove-Variable -Name Shortcut -ErrorAction SilentlyContinue

# Create Windows Credential Manager Shortcut
$Shortcut = Join-Path -Path (Resolve-Path $Shell.SpecialFolders("programs")) -ChildPath "Credential Manager.lnk"
if (-not (Test-Path -Path $Shortcut)) {
    Create-Shortcut -Link $Shortcut `
    -App "$ENV:SystemRoot\System32\control.exe" `
    -Arguments "/name Microsoft.CredentialManager" `
    -Icon "$ENV:SystemRoot\System32\imageres.dll, 54" `
    -Description "Windows Credential Manager" `
}
Remove-Variable -Name Shortcut -ErrorAction SilentlyContinue

# Windows Credential Backup Utility Shortcut
$Shortcut = Join-Path -Path (Resolve-Path $Shell.SpecialFolders("programs")) -ChildPath "Credential Backup Utility.lnk"
if (-not (Test-Path -Path $Shortcut)) {
    Create-Shortcut -Link $Shortcut `
    -App "$ENV:SystemRoot\System32\credwiz.exe" `
    -Icon "$ENV:SystemRoot\System32\credwiz.exe" `
    -Description "Windows Credential Backup Utility" `
}
Remove-Variable -Name Shortcut -ErrorAction SilentlyContinue

# Administrative Tools Shortcut
#Create-Shortcut -Link "$Env:AppData\Microsoft\Windows\Start Menu\Programs\Administrative Tools.lnk" `
#                -App "$Env:SystemRoot\System32\control.exe" `
#                -Arguments "/name Microsoft.AdministrativeTools" `
#                -Icon "%SystemRoot%\System32\imageres.dll, 109" `
#                -Description "Administrative Tools" `

# Active Directory Administration Center Shortcut
#Create-Shortcut -Link "$Env:AppData\Microsoft\Windows\Start Menu\Programs\dsac.lnk" `
#                -App "$Env:SystemRoot\System32\runas.exe" `
#                -Arguments "/noprofile /env /savecred /user:$Env:FAPS ""cmd /C Start /B %SYSTEMROOT%\System32\dsac.exe""" `
#                -Icon "%SystemRoot%\System32\dsac.exe" `
#                -Description "Active Directory Administration Center" `

# Active Directory Users & Computers Shortcut
#Create-Shortcut -Link "$Env:AppData\Microsoft\Windows\Start Menu\Programs\ad.lnk" `
#                -App "$Env:SystemRoot\System32\runas.exe" `
#                -Arguments "/noprofile /env /savecred /user:$Env:FAPS ""cmd /C Start /B %SYSTEMROOT%\System32\mmc.exe %SYSTEMROOT%\System32\dsa.msc""" `
#                -Icon "%SystemRoot%\system32\dsadmin.dll, 0" `
#                -Description "Active Directory Users & Computers" `

# Create Environment Variables Shortcut
$Shortcut = Join-Path -Path (Resolve-Path $Shell.SpecialFolders("programs")) -ChildPath "Environment Variables.lnk"
if (-not (Test-Path -Path $Shortcut)) {
    Create-Shortcut -Link $Shortcut `
    -App "$ENV:SystemRoot\System32\rundll32.exe" `
    -Arguments "sysdm.cpl,EditEnvironmentVariables" `
    -Icon "$ENV:SystemRoot\System32\shell32.dll, 167" `
    -Description "Environment Variables"
}
Remove-Variable -Name Shortcut -ErrorAction SilentlyContinue

# Create Hosts File Shortcut
$Shortcut = Join-Path -Path (Resolve-Path $Shell.SpecialFolders("programs")) -ChildPath "Hosts File.lnk"
if (-not (Test-Path -Path $Shortcut)) {
    Create-Shortcut -Link $Shortcut `
    -App "$ENV:SystemRoot\System32\notepad.exe" `
    -Arguments "$ENV:SystemRoot\System32\drivers\etc\hosts" `
    -Icon "$ENV:SystemRoot\System32\imageres.dll, 73" `
    -Description "Edit the Hosts file with Notepad, running as Administrator" `
    -Admin
}
Remove-Variable -Name Shortcut -ErrorAction SilentlyContinue

# Create System Restore Shortcut
$Shortcut = Join-Path -Path (Resolve-Path $Shell.SpecialFolders("programs")) -ChildPath "System Restore.lnk"
if (-not (Test-Path -Path $Shortcut)) {
    Create-Shortcut -Link $Shortcut `
    -App "$ENV:SystemRoot\System32\rstrui.exe" `
    -Icon "$ENV:SystemRoot\System32\rstrui.exe" `
    -Description "Recover your system, using System Restore Point" `
    -Admin
}
Remove-Variable -Name Shortcut -ErrorAction SilentlyContinue

# Create System Restore Point Shortcut
$Shortcut = Join-Path -Path (Resolve-Path $Shell.SpecialFolders("programs")) -ChildPath "Create Instant System Restore Point.lnk"
if (-not (Test-Path -Path $Shortcut)) {
    Create-Shortcut -Link $Shortcut `
    -App "$ENV:UserProfile\.config\vbs\Instant_Restore_Point.vbs" `
    -Icon "%SystemRoot%\System32\bootux.dll, 20" `
    -Description "Create Instant System Restore Point" `
    -Admin
}
Remove-Variable -Name Shortcut -ErrorAction SilentlyContinue

Remove-Variable -Name Shell -ErrorAction SilentlyContinue