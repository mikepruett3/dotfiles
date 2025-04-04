Function Get-SHA256Hash {
    <#
    .SYNOPSIS
    Quick commands to return a SHA256 Checksum of a file
    .DESCRIPTION
    Quick commands to return a SHA256 Checksum of a file
    .PARAMETER $file
    File name to retrieve the checksum. (Path needs to be included if the file is not in the same folder)
    .EXAMPLE
    Get-SHA256Hash -file <path-to-file>
    #>
    Param (
        [string]$file
    )

    $Hash = $(Get-FileHash -Path $file -Algorithm SHA256 | Select-Object -ExpandProperty Hash)
    Return $Hash
}
