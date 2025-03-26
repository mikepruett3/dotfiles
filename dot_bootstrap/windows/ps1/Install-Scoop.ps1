<#
.SYNOPSIS
  Install's the command-line installer, scoop
.DESCRIPTION
  Download's and installs scoop for the current user
.NOTES
  Author: Mike Pruett
  Date: March 23rd, 2025
.EXAMPLE
  > Install-Scoop
#>

[CmdletBinding()]
param ()

$VerbosePreference = "Continue"

Write-Verbose "Checking to see if scoop is already installed..."
if (!(Get-Command -Name "scoop" -CommandType Application -ErrorAction SilentlyContinue)) {
    Write-Verbose "Installing scoop package manager..."
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
} else {
    Write-Verbose "scoop already installed!!!"
}

if (!($(scoop bucket list).Name -eq "extras")) {
    Write-Verbose -Message "Adding Bucket extras to scoop..."
    scoop bucket add extras
} else {
    Write-Verbose -Message "Bucket extras already added! Skipping..."
}

if (!($(scoop bucket list).Name -eq "foosel")) {
    Write-Verbose -Message "Adding Bucket foosel to scoop..."
    scoop bucket add foosel https://github.com/foosel/scoop-bucket
} else {
    Write-Verbose -Message "Bucket foosel already added! Skipping..."
}
