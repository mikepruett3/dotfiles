<#
.SYNOPSIS
  Install's the Sudo package
.DESCRIPTION
  Download's and installs gerardog's sudo package, if its not already installed
.NOTES
  Author: Mike Pruett
  Date: March 23rd, 2025
.EXAMPLE
  > Install-Sudo
#>

[CmdletBinding()]
param ()

$VerbosePreference = "Continue"

Write-Verbose "Checking to see if sudo is already installed..."
if (!(Get-Command -Name "sudo" -CommandType Application -ErrorAction SilentlyContinue)) {
  Write-Verbose "Installing sudo package manager..."
  winget install --id gerardog.gsudo --source winget
} else {
  Write-Verbose "Sudo already installed!!!"
}
