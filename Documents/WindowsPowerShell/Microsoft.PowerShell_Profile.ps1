# Shell customization settings
$Shell = $Host.UI.RawUI

# Custom Module Import
If ( Test-Path -Path $ENV:USERPROFILE\.config\PowerShell\Custom.ps1 ) {
    . $ENV:USERPROFILE\.config\PowerShell\Custom.ps1
}

# Custom Function Import
ForEach ($Function in $(Get-ChildItem -Path $ENV:USERPROFILE\.config\PowerShell\Functions -Filter *.ps1)) {
    Import-Module -Name $Function.FullName -ErrorAction SilentlyContinue
}
Remove-Variable -Name "Function" -ErrorAction SilentlyContinue

# Create the Scripts: drive
# http://stackoverflow.com/a/146945
#If ((Test-Path -Path "$HOME\scripts") -and (Test-Path -Path "$HOME\Projects")) {
#    $NULL = New-PSDrive -Name X -PSProvider FileSystem -Root "$HOME\scripts"
#    $NULL = New-PSDrive -Name P -PSProvider FileSystem -Root "$HOME\Projects"
#}

# Set EDITOR variable & function
if (-not ($ENV:EDITOR)) {
    if (Get-Command -Name nano -ErrorAction SilentlyContinue) {
        [System.Environment]::SetEnvironmentVariable('EDITOR','nano', 'User')
    } elseif (Get-Command -Name nvim -ErrorAction SilentlyContinue) {
        [System.Environment]::SetEnvironmentVariable('EDITOR','nvim', 'User')
    } elseif (Get-Command -Name vim -ErrorAction SilentlyContinue) {
        [System.Environment]::SetEnvironmentVariable('EDITOR','vim', 'User')
    } else {
        [System.Environment]::SetEnvironmentVariable('EDITOR','notepad', 'User')
    }
} else {
    Function EDITOR($Path) {
        & $ENV:EDITOR $Path
    }
    Set-Variable -Name EDITOR -Value $ENV:EDITOR -Scope Global
}

# Set VISUAL variable & function
if (-not ($ENV:VISUAL)) {
    if (Get-Command -Name code -ErrorAction SilentlyContinue) {
        [System.Environment]::SetEnvironmentVariable('VISUAL','code', 'User')
    } elseif (Get-Command -Name nano -ErrorAction SilentlyContinue) {
        [System.Environment]::SetEnvironmentVariable('VISUAL','nano', 'User')
    } elseif (Get-Command -Name nvim -ErrorAction SilentlyContinue) {
        [System.Environment]::SetEnvironmentVariable('VISUAL','nvim', 'User')
    } elseif (Get-Command -Name vim -ErrorAction SilentlyContinue) {
        [System.Environment]::SetEnvironmentVariable('VISUAL','vim', 'User')
    } else {
        [System.Environment]::SetEnvironmentVariable('VISUAL','notepad', 'User')
    }
} else {
    Function VISUAL($Path) {
        & $ENV:VISUAL $Path
    }
    Set-Variable -Name VISUAL -Value $ENV:VISUAL -Scope Global
}

# Remove existing aliases from Shell
if (Get-Command -Name eza.exe -ErrorAction SilentlyContinue) {
    Remove-Item Alias:ls -Force
    $EZA_OPTIONS = @('--hyperlink','--icons')
    Function ls($Path) {
        & eza.exe $EZA_OPTIONS $Path
    }
    Function ll($Path) {
        & eza.exe $EZA_OPTIONS -l $Path
    }
    Function l($Path) {
        & eza.exe $EZA_OPTIONS -la $Path
    }
} else {
    Function ls($Path) {
        Get-ChildItem -Name -Force $Path
    }
    Function ll($Path) {
        Get-ChildItem -Force $Path
    }
}
if (Get-Command -Name wget2.exe -ErrorAction SilentlyContinue) {
    Remove-Item Alias:wget -Force
    Set-Alias -Name wget -Value wget2
} elseif (Get-Command -Name wget.exe -ErrorAction SilentlyContinue) {
    Remove-Item Alias:wget -Force
}
if (Get-Command -Name curl.exe -ErrorAction SilentlyContinue) {
    Remove-Item Alias:curl -Force
}
if (!(Get-Command -Name grep.exe -ErrorAction SilentlyContinue)) {
    Set-Alias -Name grep -Value Select-String
    Set-Alias -Name grepr -Value Select-StringRecurse
}
if (Get-Command -Name bat.exe -ErrorAction SilentlyContinue) {
    Remove-Item Alias:cat -Force
    Function cat($Path) {
        & bat.exe $Path
    }
}

# inline functions, aliases and variables
# https://github.com/scottmuc/poshfiles
Function which($Name) {
    Get-Command $Name |
    Select-Object Definition
}

Function rmf($Item) {
    Remove-Item $Item -Recurse -Force
}

Function touch($File) {
    "" | Out-File $File -Encoding ASCII
}

function dwn {
    Set-Location -Path ~\Downloads
}

function dev {
    if (Test-Path -Path ~\Development) {
        Set-Location -Path ~\Development
    }
    if (Test-Path -Path ~\Projects) {
        Set-Location -Path ~\Projects
    }
}

function home {
    Set-Location -Path ~\
}

Function Remove-AllPSSessions {
    Get-PSSession |
    Remove-PSSession
}

function updp {
    & chezmoi.exe -v update
}

#function upps {
#    $Tools = @("ps-vmtools", "ps-certtools")
#    foreach ($Tool in $Tools) {
#        Push-Location -Path $Env:ProgramFiles\WindowsPowerShell\Modules\$Tool
#        & sudo git.exe pull
#        Pop-Location
#    }
#}

function lc {
    Get-ChildItem -File |
    Rename-Item -NewName { $_.FullName.ToLower() }
}

function rusc {
    Get-ChildItem -File |
    Rename-Item -NewName { $_.Name -replace ' ','_' }
}

function rnn($Number) {
    Get-ChildItem -File |
    Rename-Item -NewName { $_.BaseName + $Number + $_.Extension }
}

function gitreset {
    & git.exe fetch --all
    & git.exe reset --hard
    & git.exe pull
}

Remove-Item -Path Alias:gp -Force
function gp($dir) {
    Push-Location -Path $dir
    & git.exe pull
    Pop-Location
}

function Unblock-Dir($Path) {
    Get-ChildItem -Path '$Path' -Recurse |
    Unblock-File
}

function mc-cp {
    Push-Location -Path $HOME
    & mc.exe cp --recursive minio .\Images\
    Pop-Location
}

function mc-mirror {
    Push-Location -Path $HOME
    & mc.exe mirror .\Images\ minio
    Pop-Location
}

function ytd($url) {
    & youtube-dl.exe $url
}

function cping($Server) {
    ping -t $Server
}

function cping2($Server) {
    while (1) {
        Test-Connection -ComputerName $Server
    }
}

function dnbradio {
    & mpv.com https://dnbradio.nl/dnbradio_main.mp3
}

function demovibes {
    & mpv.com http://necta.burn.net:8000/nectarine
}

# Alias definitions
Set-Alias -Name sta -Value Start-Transcript
Set-Alias -Name str -Value Stop-Transcript
Set-Alias -Name hh -Value Get-History
Set-Alias -Name gcid -Value Get-ChildItemDirectory
Set-Alias -Name ia -Value Invoke-Admin
Set-Alias -Name ica -Value Invoke-CommandAdmin
Set-Alias -Name isa -Value Invoke-ScriptAdmin
Set-Alias -Name kpss -Value Remove-AllPSSessions
Set-Alias -Name vi -Value EDITOR
Set-Alias -Name ssh-copy-id -Value Copy-SSHKey

# Chocolatey profile
$ChocolateyProfile = "$ENV:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Load Starship Cross-Shell Prompt
If ( Get-Command -Name "starship.exe" ) {
    $ENV:STARSHIP_DISTRO = ""
    Invoke-Expression (&starship init powershell)
}
