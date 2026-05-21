function Connect-QCSSH {
    <#
    .SYNOPSIS
        Connects to an ivcon AtriskCloud server via SSH.
    .DESCRIPTION
        Establishes an SSH connection to ic<QC>.ivcon.atriskcloud.net using the
        supplied credentials. If sshpass is available, it will be used to pass
        the password non-interactively. Falls back to plain ssh if sshpass is
        not found or no password is provided.

        Password resolution order:
          1. -Password parameter supplied at runtime (sshpass -p)
          2. $ENV:SSHPASS environment variable (sshpass -e)
          3. Plain ssh (no password automation)

        Username resolution order:
          1. -Username parameter supplied at runtime
          2. $ENV:SSI_USER environment variable
          3. Default: ydadmin
    .PARAMETER QC
        The QC number of the target server (e.g. "123" resolves to ic123.ivcon.atriskcloud.net).
    .PARAMETER Username
        The SSH username. Defaults to $ENV:SSI_USER, or 'ydadmin' if unset.
    .PARAMETER Password
        The SSH password. If provided, sshpass -p is used. If omitted and
        $ENV:SSHPASS is set, sshpass -e is used instead.
    .PARAMETER Command
        An optional command to run non-interactively on the remote host.
        If omitted, an interactive SSH session is opened.
    .EXAMPLE
        > Connect-QCSSH 123
        Opens an interactive SSH session to ic123.ivcon.atriskcloud.net as ydadmin.
    .EXAMPLE
        > Connect-QCSSH 123 -Username admin -Password s3cr3t
        Connects to ic123.ivcon.atriskcloud.net as admin using sshpass -p.
    .EXAMPLE
        > $ENV:SSHPASS = 's3cr3t'; Connect-QCSSH 123
        Connects using the password stored in $ENV:SSHPASS via sshpass -e.
    .EXAMPLE
        > Connect-QCSSH 123 "uptime"
        Runs the 'uptime' command non-interactively on ic123.ivcon.atriskcloud.net.
    .NOTES
        Requires sshpass to be installed and in $PATH for password automation.
        sshpass can typically be installed via your package manager (e.g. apt, brew).
        Without sshpass, the function falls back to plain ssh (password prompt or key auth).
    #>

    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$QC,
        [Parameter(Mandatory = $false)]
        [string]$Username = $(if ($env:SSI_USER) { $env:SSI_USER } else { 'ydadmin' }),
        [Parameter(Mandatory = $false)]
        [string]$Password,
        [Parameter(Position = 1, Mandatory = $false)]
        [string]$Command
    )

    begin {
        $sshpass  = Get-Command sshpass -ErrorAction SilentlyContinue
        $hostName = "ic${QC}.ivcon.atriskcloud.net"
        $target   = "${Username}@${hostName}"

        Write-Verbose "Target host  : $hostName"
        Write-Verbose "Target user  : $Username"
        Write-Verbose "sshpass      : $(if ($sshpass) { $sshpass.Source } else { 'not found' })"
        Write-Verbose "Command      : $(if ($Command) { $Command } else { '(interactive)' })"
    }

    process {
        if ($sshpass -and $PSBoundParameters.ContainsKey('Password')) {
            Write-Verbose "Using sshpass with runtime-supplied password (-p)"
            if ([string]::IsNullOrWhiteSpace($Command)) {
                & $sshpass.Source -p $Password ssh $target
            } else {
                & $sshpass.Source -p $Password ssh $target $Command
            }
        } elseif ($sshpass -and -not [string]::IsNullOrWhiteSpace($env:SSHPASS)) {
            Write-Verbose "Using sshpass with `$ENV:SSHPASS (-e)"
            if ([string]::IsNullOrWhiteSpace($Command)) {
                & $sshpass.Source -e ssh $target
            } else {
                & $sshpass.Source -e ssh $target $Command
            }
        } else {
            if (-not $sshpass) {
                Write-Verbose "sshpass not found — falling back to plain ssh"
            } else {
                Write-Verbose "No password provided — using plain ssh"
            }
            if ([string]::IsNullOrWhiteSpace($Command)) {
                ssh $target
            } else {
                ssh $target $Command
            }
        }

        if ($LASTEXITCODE -ne 0) {
            Write-Error "SSH connection to $target failed (exit code $LASTEXITCODE)"
        }
    }

    end {
        Write-Verbose "Cleaning up variables"
        Remove-Variable -Name sshpass, hostName, target -ErrorAction SilentlyContinue
    }
}
