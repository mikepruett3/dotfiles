<#
.SYNOPSIS
  Install's the Base packages
.DESCRIPTION
  Download's and installs base required packages, if its not already installed
.NOTES
  Author: Mike Pruett
  Date: March 23rd, 2025
.EXAMPLE
  > Install-Packages
#>

[CmdletBinding()]
param ()

Import-Module -Name $ENV:USERPROFILE\.bootstrap\windows\ps-functions\Install-WinGetPackage.ps1

Install-WinGetPackage -PackageID "Git.Git"

Remove-Module -Name Install-WinGetPackage -ErrorAction SilentlyContinue
