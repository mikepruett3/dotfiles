<#
.SYNOPSIS
  Install's the dotposh repo
.DESCRIPTION
  Download's and install's my dotposh repo, if its not already installed
.NOTES
  Author: Mike Pruett
  Date: March 27th, 2025
.EXAMPLE
  > Install-dotposh.ps1
#>

[CmdletBinding()]
param ()

$VerbosePreference = "Continue"

Write-Verbose "Checking to see if dotposh has already installed..."
if (!(Test-Path -Path $ENV:USERPROFILE\dotposh -PathType Container)) {
    git clone https://github.com/mikepruett3/dotposh.git $ENV:USERPROFILE\dotposh
} else {
    Write-Verbose "dotposh already installed!!!"
}

Write-Verbose "Checking to see if WindowsPowerShell directory exists, in $ENV:USERPROFILE\Documents..."
if (!(Test-Path -Path $ENV:USERPROFILE\Documents\WindowsPowerShell -PathType Container)) {
    New-Item -ItemType Directory -Path $ENV:USERPROFILE\Documents\WindowsPowerShell -Force
} else {
    Write-Verbose "WindowsPowerShell directory already exists!!!"
}

Write-Verbose "Checking to see if Microsoft.PowerShell_profile.ps1 directory exists, in $ENV:USERPROFILE\Documents\WindowsPowerShell..."
if (!(Test-Path -Path $ENV:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 -PathType Leaf)) {
    Start-Process -FilePath "$Env:ComSpec" `
    -Verb RunAs `
    -ArgumentList `
    "/c", `
    "mklink", `
    "%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1", `
    "%USERPROFILE%\dotposh\profile.ps1"
} else {
    Write-Verbose "Microsoft.PowerShell_profile.ps1 already exists!!!"
}
