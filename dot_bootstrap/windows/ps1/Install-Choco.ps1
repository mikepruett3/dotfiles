<#
.SYNOPSIS
  Install's the command-line installer, choco
.DESCRIPTION
  Download's and installs choco, if its not already installed
.NOTES
  Author: Mike Pruett
  Date: March 23rd, 2025
.EXAMPLE
  > Install-Choco
#>

[CmdletBinding()]
param ()

Write-Verbose "Checking to see if choco is already installed..."
if (!(Get-Command -Name "choco" -CommandType Application)) {
  Write-Verbose "Installing choco package manager..."
  winget install --id chocolatey.chocolatey --source winget
} else {
  Write-Verbose "Choco already installed!!!"
}
