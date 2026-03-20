function Remove-HostFromKnownHosts {
    <#
    .SYNOPSIS
        Removes entries from the SSH known_hosts file matching the specified computer name.
    .DESCRIPTION
        This function searches the SSH known_hosts file for entries that match the specified computer name
        and removes them. It supports wildcard patterns for flexible matching.
    .NOTES
        This function requires PowerShell 5.0 or later. Code Borrowed from:
        https://community.ops.io/kaiwalter/remove-entries-from-knownhosts-with-powershell-48l6
    .PARAMETER ComputerName
        The name of the computer to remove from the known_hosts file. Supports wildcard patterns.
    .EXAMPLE
        > Remove-HostFromKnownHosts -ComputerName "example.com"
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [SupportsWildcards()]
        [string]
        $ComputerName
    )

    begin {
        Write-Verbose "Creating known_hosts file path variable"
        $KnownHostsFile = (Join-Path $HOME ".ssh") + "\known_hosts"
    }

    process{
        if (Test-Path $KnownHostsFile -PathType Leaf) {
            Write-Verbose "Reading contents of $KnownHostsFile"
            $Contents = Get-Content $KnownHostsFile -Raw

            if ($Contents) {
                Write-Verbose "Determining line ending format in $KnownHostsFile"
                if ($Contents -match "^[^\n]+\r\n") {
                    $Splitter = "\r\n"
                    $Joiner = "`r`n"
                } else {
                    $Splitter = "\n"
                    $Joiner = "`n"
                }

                Write-Verbose "Creating wildcard pattern for $ComputerName"
                $pattern = [System.Management.Automation.WildcardPattern]::new(
                    $ComputerName,
                    [System.Management.Automation.WildcardOptions]::IgnoreCase
                )

                Write-Verbose "Splitting contents of $KnownHostsFile into lines and filtering out empty lines"
                $listIn = [regex]::Split($Contents, $Splitter) | Where-Object { $_ -ne "" }

                Write-Verbose "Filtering lines that match the pattern for $ComputerName"
                $listOut = $listIn | Where-Object {
                    # Split the host field (first token) by comma to handle
                    # entries with multiple hostnames (e.g. "host1,192.168.1.1 keytype key")
                    $hosts = ($_ -split '\s+')[0] -split ','
                    -not ($hosts | Where-Object { $pattern.IsMatch($_) })
                }

                Write-Verbose "Comparing the number of lines before and after filtering"
                if ($listOut.Count -ne $listIn.Count) {
                    Write-Verbose "removed $($listIn.Count - $listOut.Count) lines"
                    $listOut -join $Joiner | Set-Content $KnownHostsFile -NoNewline
                }
            } else {
                throw "file $KnownHostsFile has no content"
            }
        } else {
            throw "file $KnownHostsFile not found"
        }
    }

    end {
        Write-Verbose "Cleaning up used Variables..."
        Remove-Variable -Name ComputerName, KnownHostsFile, Contents, Splitter, Joiner, pattern, listIn, listOut -ErrorAction SilentlyContinue
    }
}