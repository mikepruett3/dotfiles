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

$VerbosePreference = "True"

begin {
  Import-Module -Name $ENV:USERPROFILE\.bootstrap\windows\ps-functions\Install-WinGetPackage.ps1

  $Packages = @(
    "FiloSottile.age",
    "sharkdp.bat",
    "aristocratos.btop4win",
    "cURL.cURL",
    "waterlan.dos2unix",
    "eza-community.eza",
    "junegunn.fzf",
    "Git.Git",
    "charmbracelet.glow",
    "GoLang.Go",
    "GnuPG.GnuPG",
    "jftuga.less",
    "gokcehan.lf",
    "Microsoft.VisualStudioCode",
    "MinIO.Client",
    "ArtifexSoftware.mutool",
    "GNU.Nano",
    "Neovim.Neovim",
    "BurntSushi.ripgrep.MSVC",
    "Starship.Starship"
  )
}

process {
  foreach ($Package in $Packages) {
    Install-WinGetPackage -PackageID $Package
  }
}

end {
  Remove-Module -Name Install-WinGetPackage -ErrorAction SilentlyContinue
}
