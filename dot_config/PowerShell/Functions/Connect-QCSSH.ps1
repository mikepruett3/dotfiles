function Connect-QCSSH {
    <#
    .SYNOPSIS
        Connects to an ivcon AtriskCloud server via SSH.
    .DESCRIPTION
        Establishes an SSH connection to ic<QC>.ivcon.atriskcloud.net using the
        supplied credentials. When a password is available (see resolution
        order below), it's supplied via SSH_ASKPASS with SSH_ASKPASS_REQUIRE=force
        rather than sshpass. ssh.exe then manages its own terminal end-to-end,
        for both interactive and non-interactive runs, with no second process
        ever touching the pty -- sshpass's own Unix-style pty emulation was the
        actual cause of a bug where a bare interactive session (no -Command)
        could leave the whole PowerShell session unresponsive after a
        successful auth. Falls back to plain ssh (password prompt or key auth)
        when no password is available.

        Password resolution order:
          1. -Password parameter supplied at runtime
          2. $ENV:SSHPASS environment variable
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
        The SSH password. If provided (or found in $ENV:SSHPASS), it's supplied
        to ssh via SSH_ASKPASS instead of a manual prompt.
    .PARAMETER Command
        An optional command to run non-interactively on the remote host.
        If omitted, an interactive SSH session is opened.
    .EXAMPLE
        > Connect-QCSSH 123
        Opens an interactive SSH session to ic123.ivcon.atriskcloud.net as ydadmin.
    .EXAMPLE
        > Connect-QCSSH 123 -Username admin -Password s3cr3t
        Connects to ic123.ivcon.atriskcloud.net as admin, password supplied via SSH_ASKPASS.
    .EXAMPLE
        > $ENV:SSHPASS = 's3cr3t'; Connect-QCSSH 123
        Connects using the password stored in $ENV:SSHPASS, supplied via SSH_ASKPASS.
    .EXAMPLE
        > Connect-QCSSH 123 "uptime"
        Runs the 'uptime' command non-interactively on ic123.ivcon.atriskcloud.net.
    .NOTES
        Relies on the askpass helper ssh-askpass.cmd alongside this function, which just
        echoes $ENV:SSHPASS to stdout for ssh to read internally -- it's never shown in
        the terminal. Requires Windows' native OpenSSH client (SSH_ASKPASS_REQUIRE
        support); no external sshpass dependency.
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
        $hostName      = "ic${QC}.ivcon.atriskcloud.net"
        $target        = "${Username}@${hostName}"
        $askpassHelper = Join-Path $PSScriptRoot 'ssh-askpass.cmd'
        $resolvedPassword = if ($PSBoundParameters.ContainsKey('Password')) { $Password } else { $env:SSHPASS }

        Write-Verbose "Target host  : $hostName"
        Write-Verbose "Target user  : $Username"
        Write-Verbose "Command      : $(if ($Command) { $Command } else { '(interactive)' })"
        Write-Verbose "Password     : $(if ([string]::IsNullOrWhiteSpace($resolvedPassword)) { 'not provided' } else { 'available (via SSH_ASKPASS)' })"
    }

    process {
        $usingAskpass = -not [string]::IsNullOrWhiteSpace($resolvedPassword) -and (Test-Path -LiteralPath $askpassHelper)

        if (-not [string]::IsNullOrWhiteSpace($resolvedPassword) -and -not (Test-Path -LiteralPath $askpassHelper)) {
            Write-Verbose "Password available but askpass helper not found at $askpassHelper — falling back to plain ssh"
        }

        if ($usingAskpass) {
            Write-Verbose "Using SSH_ASKPASS ($askpassHelper)"
            # Save/restore rather than mutate the caller's session: these three vars are
            # only meaningful for the duration of this one ssh invocation.
            $previousSshpass        = $env:SSHPASS
            $previousAskpass        = $env:SSH_ASKPASS
            $previousAskpassRequire = $env:SSH_ASKPASS_REQUIRE
            try {
                $env:SSHPASS             = $resolvedPassword
                $env:SSH_ASKPASS         = $askpassHelper
                $env:SSH_ASKPASS_REQUIRE = 'force'
                if ([string]::IsNullOrWhiteSpace($Command)) {
                    ssh $target
                } else {
                    ssh $target $Command
                }
            } finally {
                $env:SSHPASS             = $previousSshpass
                $env:SSH_ASKPASS         = $previousAskpass
                $env:SSH_ASKPASS_REQUIRE = $previousAskpassRequire
            }
        } else {
            Write-Verbose "No password available — using plain ssh"
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
        Remove-Variable -Name hostName, target, askpassHelper, resolvedPassword, usingAskpass -ErrorAction SilentlyContinue
    }
}
