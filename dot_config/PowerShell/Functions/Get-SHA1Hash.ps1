Function Get-SHA1Hash {
    <#
    .SYNOPSIS
    Quick commands to return a SHA1 Checksum of a file
    .DESCRIPTION
    Quick commands to return a SHA1 Checksum of a file
    .PARAMETER $file
    File name to retrieve the checksum. (Path needs to be included if the file is not in the same folder)
    .EXAMPLE
    Get-SHA1Hash -file <path-to-file>
    #>
    Param (
        [string]$file
    )

    $Hash = $(Get-FileHash -Path $file -Algorithm SHA1 | Select-Object -ExpandProperty Hash)
    Return $Hash
}
