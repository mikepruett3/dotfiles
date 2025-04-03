#Dot source the files
$Functions = @( Get-ChildItem -Path $PSScriptRoot\Public\ -Filter *.ps1 -ErrorAction SilentlyContinue )

foreach ($Function in @($Functions)) {
    Import-Module $Function.FullName -Verbose
}

Export-ModuleMember -Function $Public.BaseName
