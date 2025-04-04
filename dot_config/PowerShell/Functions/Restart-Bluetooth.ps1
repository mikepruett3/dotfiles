Function Restart-Bluetooth {
    <#
    .SYNOPSIS
    Quick command to restart Bluetooth services
    .DESCRIPTION
    Function to get all of the associated Bluetooth services, and restart them
    .EXAMPLE
    > Restart-Bluetooth
    #>

    [CmdletBinding()]
    Param ()

    foreach ( $Service in (Get-Service -DisplayName *Bluetooth* | Where-Object { $_.Name -ne "bthserv" } | Select-Object Name).Name ) {
        gsudo Restart-Service -Name $Service
    }
}