function Install-WinGetPackage {
    <#
    .SYNOPSIS
      Function that installs a WinGet package
    .DESCRIPTION
      Install's a specific WinGet package, if its not already installed
    .NOTES
      Author: Mike Pruett
      Date: March 23rd, 2025
    .PARAMETER PackageID
      WinGet Package ID to install
    .PARAMETER Sudo
      Wether or not to run WinGet as sudo
    .EXAMPLE
      > Install-WinGetPackage -PackageID xxx
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [string]
        $PackageID,
        [Parameter(Mandatory=$False,ValueFromPipeline=$True)]
        [switch]
        $Sudo
    )

    if (winget list --id $PackageID -eq $False) {
      if ($Sudo) {
        Write-Verbose -Message "Install $PackageID..."
        sudo winget install --silent `
          --id $PackageID
          #--accept-source-agreements `
          #--accept-package-agreements
      } else {
        Write-Verbose -Message "Install $PackageID..."
        winget install --silent `
          --id $PackageID
          #--accept-source-agreements `
          #--accept-package-agreements
      }
    } else {
      Write-Verbose -Message "$PackageID already installed!"
    }
}
