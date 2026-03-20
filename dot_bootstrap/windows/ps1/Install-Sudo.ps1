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

Write-Verbose "Getting OS version information..."
$OS_VERSION = (Get-CimInstance Win32_OperatingSystem).Caption
Write-Verbose "OS Version: $OS_VERSION"

Write-Verbose "Checking to see if sudo is already installed..."
if ($OS_VERSION.Contains("Windows 11")) {
  Write-Verbose "Checking current sudo configuration..."
  $CURRENT_SUDO_CONFIG = sudo config
  if ($CURRENT_SUDO_CONFIG -notmatch "Inline") {
    Write-Verbose "Enabling Inline (normal) mode for sudo..."
    sudo config --enable normal
  }
  Return
} else {
  if (!(Get-Command -Name "sudo" -CommandType Application -ErrorAction SilentlyContinue)) {
    Write-Verbose "Installing sudo package manager..."
    winget install --id gerardog.gsudo --source winget
  } else {
    Write-Verbose "Sudo already installed!!!"
  }
}
