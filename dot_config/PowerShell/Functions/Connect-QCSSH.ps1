function Connect-QCSSH {
    <#
    .SYNOPSIS
        Connects to an ivcon AtriskCloud server via SSH.
    .DESCRIPTION
        Establishes an SSH connection to ic<QC>.ivcon.atriskcloud.net using the
        supplied credentials. When a password is available AND a -Command was
        given (a non-interactive run), it's supplied via SSH_ASKPASS with
        SSH_ASKPASS_REQUIRE=force -- confirmed reliable for that case. A bare
        interactive session (no -Command) always uses plain ssh instead, even
        when a password is available: Windows' native OpenSSH client appears
        to take a different, GUI-oriented code path for SSH_ASKPASS when a
        real console/window-station is attached (as opposed to a headless
        context), and that path did not reliably invoke our stdout-based
        askpass helper in testing -- the ssh call returned immediately with no
        output and no error. sshpass was tried here previously and rejected
        for the same class of problem (it left the whole PowerShell session
        unresponsive after a successful interactive auth), so the safest known
        behavior for an interactive session is a plain ssh password prompt --
        you'll be prompted once.

        Password resolution order (non-interactive -Command runs only):
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
        the terminal. Only used for non-interactive -Command runs; a bare interactive
        session always uses plain ssh, regardless of password availability (see
        DESCRIPTION for why). No external sshpass dependency either way.
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
        $isInteractive = [string]::IsNullOrWhiteSpace($Command)
        $havePassword  = -not [string]::IsNullOrWhiteSpace($resolvedPassword)
        $haveHelper    = Test-Path -LiteralPath $askpassHelper
        # See DESCRIPTION: askpass is only trusted here for non-interactive -Command
        # runs. A bare interactive session always falls through to plain ssh below,
        # even when a password is available.
        $usingAskpass  = -not $isInteractive -and $havePassword -and $haveHelper

        if ($usingAskpass) {
            Write-Verbose "Using SSH_ASKPASS ($askpassHelper) for this non-interactive command"
            # Save/restore rather than mutate the caller's session: these three vars are
            # only meaningful for the duration of this one ssh invocation.
            $previousSshpass        = $env:SSHPASS
            $previousAskpass        = $env:SSH_ASKPASS
            $previousAskpassRequire = $env:SSH_ASKPASS_REQUIRE
            try {
                $env:SSHPASS             = $resolvedPassword
                $env:SSH_ASKPASS         = $askpassHelper
                $env:SSH_ASKPASS_REQUIRE = 'force'
                ssh $target $Command
            } finally {
                $env:SSHPASS             = $previousSshpass
                $env:SSH_ASKPASS         = $previousAskpass
                $env:SSH_ASKPASS_REQUIRE = $previousAskpassRequire
            }
        } else {
            if ($isInteractive -and $havePassword) {
                Write-Verbose "Interactive session -- using plain ssh even though a password is available (see NOTES); you'll be prompted once."
            } elseif (-not $havePassword) {
                Write-Verbose "No password available — using plain ssh"
            } elseif (-not $haveHelper) {
                Write-Verbose "Password available but askpass helper not found at $askpassHelper — falling back to plain ssh"
            }
            if ($isInteractive) {
                ssh $target
            } else {
                ssh $target $Command
            }
        }

        # ssh's own exit-code convention: 255 means ssh itself couldn't establish/complete
        # the connection (DNS, auth, network, etc). Any other nonzero code just came from
        # whatever ran on the far end (the remote shell or -Command) -- e.g. typing a typo'd
        # command and then a bare `exit` in an interactive session propagates that command's
        # exit code to the whole ssh process, which is completely normal and not a
        # connection failure. Only 255 is actually worth reporting here.
        if ($LASTEXITCODE -eq 255) {
            Write-Error "SSH connection to $target failed (exit code $LASTEXITCODE)"
        }
    }

    end {
        Write-Verbose "Cleaning up variables"
        Remove-Variable -Name hostName, target, askpassHelper, resolvedPassword, usingAskpass -ErrorAction SilentlyContinue
    }
}
