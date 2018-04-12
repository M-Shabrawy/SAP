trap [Exception] 
{
	write-error $("Exception: " + $_)
	exit 1
}

$FormatIsUnicode = $true

$LogPath = (#Source#,#Destination#),
           (#Source#,#Destination#),
           (#Source#,#Destination#),

foreach ($Path in $LogPath)
{
    $SourcePath = $Path[0]
    $OutputPath = $Path[1]
    $StatePath = $OutputPath + 'state'
    
    if(! (Test-Path $OutputPath))
    {
        mkdir $OutputPath
    }

    if(!(Test-Path $StatePath))
    {
        mkdir $StatePath
    }
    
    $AuditFiles = Get-ChildItem "$SourcePath*.AUD"

    Foreach ($file in $AuditFiles)
    {
        $StateFile = $OutputPath + 'state\' + $file.BaseName + '.stat'
        $AuditFile = $OutputPath + $file.Name
        $TempFile = $OutputPath + $file.BaseName + '.tmp'
        $OutputFile = $OutputPath + $file.BaseName + '.log'

        if (Test-Path -Path $StateFile) 
        {
            Write-Host "State file found for "$file.Name
            [decimal]$Length = Get-Content $StateFile
            if ($file.Length -gt $Length)
            {
                Write-Host "File Changed "$file.Name
                Copy-Item -Path $file.FullName -Destination $OutputPath
                Write-Host "File Copied "$file.Name
                if ($FormatIsUnicode -eq $true)
                {
                    get-content -Path $AuditFile -Encoding Unicode | sc $TempFile -encoding utf8 -Force
                    (get-content $Tempfile) -replace ".{200}" , "$&`r`n" | sc $OutputFile -Force
                }
                else
                {
                    get-content -Path $AuditFile | out-file $TempFile -Force
			            (get-content $Tempfile) -replace ".{200}" , "$&`r`n" | sc $OutputFile -Force
                }
                Write-Host "File Converted "$file.Name
                $file.Length | Out-File -FilePath $StateFile -Force
                Remove-Item $AuditFile -Force
                Remove-Item $Tempfile -Force
            }
        }
        else
        {
            Write-Host "New File "$file.Name
            Copy-Item -Path $file.FullName -Destination $OutputPath -Force
            Write-Host "File Copied "$file.Name
             if ($FormatIsUnicode -eq $true)
                {
                    Write-Host "Unicode File format"
                    get-content -Path $AuditFile -encoding unicode | out-file $TempFile -encoding utf8
			            (get-content $Tempfile) -replace ".{200}" , "$&`r`n" | sc $OutputFile -Force
                }
                else
                {
                    get-content -Path $AuditFile | out-file $TempFile
			            (get-content $Tempfile) -replace ".{200}" , "$&`r`n" | sc $OutputFile -Force
                }
            Write-Host "File Converted "$file.Name
            $file.Length | Out-File -FilePath $StateFile -Force
            Remove-Item $AuditFile -Force
            Remove-Item $Tempfile -Force
        }
        
         
    }

}
exit 0
