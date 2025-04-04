function Copy-SSHKey {
    <#
    .SYNOPSIS
        Copy the SSH Public Key to a server
    .DESCRIPTION
        Like the Unix equivalent, ssh-copy-id... this cmdlet will open
        an SSH session to the server, and copy the contents of the SSH
        Public Key to the .ssh/authorized_keys on the remote server.
    .PARAMETER Server
        Server name to copy the SSH Public Key
    .PARAMETER Credentials
        Credentials (Username and Password) used to connect to the
        remote server. Use BetterCredentials to make this process
        easier
    .PARAMETER Key
        Path to the SSH Public Key to copy to the server. Cmdlet will
        use the Default Public Key $Env:UserProfile\.ssh\id_rsa.pub,
        if available
    .EXAMPLE
        > Copy-SSHKey -Server myserver.example.com -Credentials myuser -Key \Path\To\Key\File.pub
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [string]
        $Server,

        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [string]
        $Credentials,

        [Parameter(Mandatory=$False,ValueFromPipeline=$True)]
        [string]
        $Key
    )

    begin {
        Write-Verbose "Looking for a SSH Key in the default location..."
        if (-not ($Key)) {
            if (Test-Path -Path $ENV:UserProfile\.ssh\id_*.pub) {
                Write-Verbose "Use the default location of the Public Key, if available"
                $KeysFound = (Get-Item -Path $ENV:UserProfile\.ssh\id_*.pub).FullName
                if (($KeysFound -match "ed25519") -and (-not ($Key))) {
                    Write-Verbose "Located a ed25519 SSH Public key..."
                    $Key = "$ENV:UserProfile\.ssh\id_ed25519.pub"
                } elseif (($KeysFound -match "ecdsa") -and (-not ($Key))) {
                    Write-Output "Located a ecdsa SSH Public key..."
                    $Key = "$ENV:UserProfile\.ssh\id_ecdsa.pub"
                } elseif (($KeysFound -match "rsa") -and (-not ($Key))) {
                    Write-Output "Located a rsa SSH Public key..."
                    $Key = "$ENV:UserProfile\.ssh\id_rsa.pub"
                } elseif (($KeysFound -match "dsa") -and (-not ($Key))) {
                    Write-Output "Located a dsa SSH Public key..."
                    $Key = "$ENV:UserProfile\.ssh\id_dsa.pub"
                }
            } else {
                Write-Error "Key not found!!!"
                Break
            }
        }

        #Write-Verbose "Load contents of SSH Public Key into variable..."
        #try {
        #    $SSHKey = Get-Content -Path $Key
        #}
        #catch {
        #    Write-Error "Key not found!!!"
        #    Break
        #}

        # Use BetterCredentials cmdlet to make this easier!
        Write-Verbose "Load Credentials into variable..."
        try {
            $Creds = Get-Credential("$Credentials")
        }
        catch {
            Write-Error "Could not retrieve the Credentials!!!"
            Break
        }

        Write-Verbose "Setting UserName variable..."
        try {
            $UserName = $Creds.GetNetworkCredential().UserName
        }
        catch {
            Write-Error "Unable to set the UserName variable!!!"
            Break
        }

        Write-Verbose "Setting Password variable..."
        try {
            $Password = $Creds.GetNetworkCredential().Password
        }
        catch {
            Write-Error "Unable to set the Password variable!!!"
            Break
        }

        Write-Verbose "Testing communication with the $Server server..."
        try {
            Test-Connection -ComputerName $Server -Count 1 -ErrorAction SilentlyContinue | Out-Null
        }
        catch {
            Write-Error "Count not communicate with $Server!!!"
            Break
        }

        Write-Verbose "Checking for plink in system path"
        if (-not (Get-Command -Name "plink.exe" -ErrorAction SilentlyContinue)) {
            Write-Error "plink.exe either not installed, or not in system path!!!"
            Break
        }

        Write-Verbose "Checking for ssh in system path"
        if (-not (Get-Command -Name ssh.exe -ErrorAction SilentlyContinue)) {
            Write-Error "ssh.exe either not installed, or not in system path!!!"
            Break
        }
    }

    process {
        $Command = "mkdir --mode=0700 -p .ssh && cat >> .ssh/authorized_keys"
        #Get-Content $Key | plink -ssh -batch "-l" $UserName "-pw" "$Password" $Server "-m" - | Out-Null
        Get-Content $Key | plink.exe -ssh -l $UserName -pw "$Password" $Server $Command -
        #try {
        #    Write-Output "$SSHKey" | plink.exe "$Server" -l "$UserName" -pw "$Password" "umask 077; test -d .ssh || mkdir .ssh ; cat >> .ssh/authorized_keys"
        #}
        #catch {
        #    Write-Error "Unable to copy the Public Key to the server!!!"
        #    Break
        #}

    }

    end {
        Write-Verbose "Cleaning up after Copying the SSH Public Key to the server $Server..."
        Remove-Variable -Name Server -ErrorAction SilentlyContinue
        Remove-Variable -Name Credentials -ErrorAction SilentlyContinue
        Remove-Variable -Name Key -ErrorAction SilentlyContinue
        Remove-Variable -Name KeysFound -ErrorAction SilentlyContinue
        #Remove-Variable -Name SSHKey -ErrorAction SilentlyContinue
        Remove-Variable -Name Creds -ErrorAction SilentlyContinue
        Remove-Variable -Name UserName -ErrorAction SilentlyContinue
        Remove-Variable -Name Password -ErrorAction SilentlyContinue
    }
}