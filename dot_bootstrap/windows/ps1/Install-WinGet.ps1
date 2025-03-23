<#
.SYNOPSIS
  Install's the command-line installer, winget
.DESCRIPTION
  Download's and installs winget, if its not already installed
.NOTES
  Author: Mike Pruett
  Date: March 23rd, 2025
.EXAMPLE
  > Install-WinGet
#>

[CmdletBinding()]
param ()

Write-Verbose "Checking to see if winget is already installed..."
if (!(Get-Command -Name "winget" -CommandType Application)) {
    Write-Verbose "Installing winget package manager..."
    # From crutkas's gist - https://gist.github.com/crutkas/6c2096eae387e544bd05cde246f23901
    #$hasPackageManager = Get-AppPackage -name "Microsoft.DesktopAppInstaller"
    if (!(Get-AppPackage -name "Microsoft.DesktopAppInstaller")) {
      Write-Verbose -Message "Installing WinGet..."
@'
# Set URL and Enable TLSv12
$releases_url = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Dont Think We Need This!!!
#Install-PackageProvider -Name NuGet
# Install Nuget as Package Source Provider
Register-PackageSource -Name Nuget -Location "http://www.nuget.org/api/v2" -ProviderName Nuget -Trusted
# Install Microsoft.UI.Xaml (This is not currently working!!!)
Install-Package Microsoft.UI.Xaml -RequiredVersion 2.7.1
# Grab "Latest" release
$releases = Invoke-RestMethod -uri $releases_url
$latestRelease = $releases.assets | Where { $_.browser_download_url.EndsWith('msixbundle') } | Select -First 1
# Install Microsoft.DesktopAppInstaller Package
Add-AppxPackage -Path $latestRelease.browser_download_url
'@ > $ENV:TEMP\winget.ps1
      Start-Process -FilePath "PowerShell" -ArgumentList $ENV:TEMP\winget.ps1 -Verb RunAs -Wait
      Remove-Item -Path $ENV:TEMP\winget.ps1 -Force
    } else {
      Write-Verbose "Winget already installed!!!"
    }
}
