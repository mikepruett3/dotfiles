Function Get-MD5Hash {
    <#
    .SYNOPSIS
    Quick commands to return a MD5 Checksum of a file
    .DESCRIPTION
    Quick commands to return a MD5 Checksum of a file
    .PARAMETER $file
    File name to retrieve the checksum. (Path needs to be included if the file is not in the same folder)
    .EXAMPLE
    Get-MD5Hash -file <path-to-file>
    #>
    Param (
        [string]$file
    )

    $Hash = $(Get-FileHash -Path $file -Algorithm MD5 | Select-Object -ExpandProperty Hash)
    Return $Hash
}
