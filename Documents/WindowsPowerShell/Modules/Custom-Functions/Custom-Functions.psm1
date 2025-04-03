#Dot source the files
Foreach ($Import in @( Get-ChildItem -Path $PSScriptRoot\Public\ -Filter *.ps1 -ErrorAction SilentlyContinue )) {
    Try {
        Import-Module $Import.FullName
    }
    Catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }
}

Export-ModuleMember -Function $Public.BaseName
