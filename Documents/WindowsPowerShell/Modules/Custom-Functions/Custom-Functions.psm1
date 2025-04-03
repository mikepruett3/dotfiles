#Dot source the files
Write-Output "$PSScriptRoot\Public\"

Foreach ($Import in @( Get-ChildItem -Path $PSScriptRoot\Public\ -Filter *.ps1 -ErrorAction SilentlyContinue )) {
    Try {
        Import-Module $Import.FullName -Verbose
    }
    Catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }
}

Export-ModuleMember -Function $Public.BaseName
