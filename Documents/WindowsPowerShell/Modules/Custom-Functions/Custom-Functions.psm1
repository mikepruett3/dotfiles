#Dot source the files
$Functions = @( Get-ChildItem -Path $PSScriptRoot\Public\ -Filter *.ps1 -ErrorAction SilentlyContinue )

foreach ($Function in @($Functions)) {
    try {
        Import-Module $Function.FullName -Verbose
    }
    catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }

}

Export-ModuleMember -Function $Functions.BaseName
