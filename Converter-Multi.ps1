trap [Exception] 
{
	write-error $("Exception: " + $_)
	exit 1
}

$FormatIsUnicode = $false

$LogPath = "T:\SAP\SAP Security Audit Log"
$LogFolders = Get-ChildItem -Path $LogPath -Attributes Directory


foreach ($Folder in $LogFolders)
{
    $AUDFolder = Get-ChildItem -Path $Folder.FullName -Attributes Directory
    $AUDFolder += '\'
    $AuditFiles = Get-ChildItem "$AUDFolder\*.AUD"

    Foreach ($file in $AuditFiles)
    {
        $TempFile = $AUDFolder + $file.BaseName + '.tmp'
        $OutputFile = $AUDFolder + $file.BaseName + '.log'
        get-content $file | out-file $TempFile -Force
	    (get-content $Tempfile) -replace ".{200}" , "$&`r`n" | sc $OutputFile -Force
        Write-Host "File Converted "$file.Namfe
              Remove-Item $Tempfile -Force       
     }

}
exit 0
