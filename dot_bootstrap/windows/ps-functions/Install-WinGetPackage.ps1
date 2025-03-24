function Install-WinGetPackage {
    <#
    .SYNOPSIS
      Function that installs a winget package
    .DESCRIPTION
      Install's a specific winget package, if its not already installed
    .NOTES
      Author: Mike Pruett
      Date: March 23rd, 2025
    .EXAMPLE
      > Install-WinGetPackage -PackageID xxx
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [string]
        $PackageID
    )

    if (!(winget list --id $PackageID)) {
        Write-Verbose -Message "Install $PackageID..."
        winget install --silent `
          --id $PackageID `
          --accept-source-agreements `
          --accept-package-agreements
    } else {
        Write-Verbose -Message "$PackageID already installed!"
    }
}
