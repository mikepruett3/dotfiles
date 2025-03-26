<#
.SYNOPSIS
  Install's a specified Nerd Font into users fonts
.DESCRIPTION
  Searches the latest Nerd Font releases for a specific font, then
  downloads and installs the fonts in the Users Profile.
.NOTES
  Author: Mike Pruett
  Date: March 23rd, 2025
.PARAMETER Name
  The name of the Nerd Font to install
.EXAMPLE
  # Install the Hack Nerd Fonts set
  > Install-NerdFonts -Name Hack
#>

[CmdletBinding()]
param (
  [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
  [string]
  $Name
)

# Suppress Progress bar for Invoke-WebRequest tasks
$ProgressPreference = "SilentlyContinue"
$VerbosePreference = "Continue"

# Link to Github API for ryanoasis's nerd fronts repository
$url ="https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest"

Write-Verbose "Creating an object with includes all of the assets from the sites contents..."
$content = ((Invoke-WebRequest -Uri $url).Content |
  ConvertFrom-Json).Assets

Write-Verbose "Locating the matching file url to download..."
$link = $content |
  Where-Object name -match "zip" |
  Where-Object name -match "$Name" |
  Select-Object -ExpandProperty browser_download_url

# Creating Fonts directory, if it does not exist
New-Item -ItemType "Directory" -Path $ENV:LOCALAPPDATA\Microsoft\Windows\Fonts -Force

if (!(Test-Path -Path $ENV:LOCALAPPDATA\Microsoft\Windows\Fonts\*$Name*)) {
  Write-Verbose "Downloading the selected Nerd Fonts zip file to %TEMP%..."
  if ($link) {
      if (!(Test-Path -Path $ENV:TEMP\$Name.zip -PathType Leaf)) {
          Invoke-WebRequest -Uri $link -OutFile $ENV:TEMP\$Name.zip
      }
  } else {
      Write-Error "No matching font found for $Name.zip"
      Break
  }

  Write-Verbose "Extracting the $Name.zip file..."
  if (!(Test-Path -Path $ENV:TEMP\$Name\ -PathType Container)) {
      Expand-Archive -Path $ENV:TEMP\$Name.zip `
        -DestinationPath $ENV:TEMP\$Name\
  }

  Write-Verbose "Processing the fonts from $ENV:TEMP\$Name\..."
  $FontList = Get-ChildItem -Path $ENV:TEMP\$Name\ -Include ('*.fon','*.otf','*.ttc','*.ttf') -Recurse
  foreach ($Font in $FontList) {
    $FontName = $Font.Name
    $BaseName = $Font.BaseName
    if (!(Test-Path -Path $ENV:LOCALAPPDATA\Microsoft\Windows\Fonts\$FontName -PathType Leaf)) {
      Write-Verbose "Installing font - $BaseName"
      Copy-Item -Path $Font -Destination $ENV:LOCALAPPDATA\Microsoft\Windows\Fonts\

      Write-Verbose "Register font $BaseName for all users"
      #Write-Output $ENV:LOCALAPPDATA\Microsoft\Windows\Fonts\$FontName
      New-ItemProperty -Name $BaseName `
        -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" `
        -PropertyType string `
        -Value $ENV:LOCALAPPDATA\Microsoft\Windows\Fonts\$FontName |
        Out-Null
    }
  }

  Write-Verbose "Cleaning up downloaded files..."
  Remove-Item -Path $ENV:TEMP\$Name\ -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item -Path $ENV:TEMP\$Name.zip -Force -ErrorAction SilentlyContinue
} else {
  Write-Verbose "$Name Nerd Fonts already installed!!!"
}

Write-Verbose "Cleaning up used Variables..."
Remove-Variable -Name "Name" -ErrorAction SilentlyContinue
Remove-Variable -Name "url" -ErrorAction SilentlyContinue
Remove-Variable -Name "content" -ErrorAction SilentlyContinue
Remove-Variable -Name "link" -ErrorAction SilentlyContinue
Remove-Variable -Name "Font" -ErrorAction SilentlyContinue
Remove-Variable -Name "FontList" -ErrorAction SilentlyContinue
Remove-Variable -Name "FontName" -ErrorAction SilentlyContinue
Remove-Variable -Name "BaseName" -ErrorAction SilentlyContinue