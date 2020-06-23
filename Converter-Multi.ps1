param(
    [Binary]$FormatIsUnicode = $true,
    [String]$TempPath = "D:\SAP Logs",
    [int]$CycleTime = -5
)
trap [Exception] 
{
	write-error $("Exception: " + $_)
	exit 1
}

$StatePath = "$TempPath\state"
if(!(Test-Path -Path $StatePath)){
    New-Item -Path $StatePath -ItemType Directory
}
$LogPaths = @{
    "Srv1" = "\\srv1\log" ; 
    "Srv2"  = "\\srv2\log";
    "Srv3" = "\\srv3\log"
}

$LogPaths | % getEnumerator | %{
    $SrvTempPath = "$TempPath\$($_.key)"
    if(!(Test-Path -Path $SrvTempPath)){
        New-Item -Path $SrvTempPath -ItemType Directory
    }
    $AuditFiles = Get-ChildItem "$($_.Value)\*.AUD"
    Foreach ($file in $AuditFiles){
        $StateFile = "$StatePath\$($file.BaseName).st"
        $TempFile = "$SrvTempPath\$($file.Name)"
        $OutputFile = "$SrvTempPath\$($file.BaseName).log"
                
        if(Test-Path -Path $StateFile){
            $StateDate = [datetime]::ParseExact((Get-Content -Path $StateFile),"yyyy/MM/dd hh:mm:ss",$null)
            if($file.LastWriteTime -gt $StateDate){
                Copy-Item $file -Destination $TempFile
                ($file.LastWriteTime).ToString() | sc $StateFile
                if($FormatIsUnicode -eq $true){
                    (get-content $TempFile -Encoding Unicode) -replace ".{200}" , "$&`r`n" | sc $OutputFile -Force
                }else{
                    (get-content $TempFile) -replace ".{200}" , "$&`r`n" | sc $OutputFile -Force
                }
                Write-Host "File Converted "$file.Name
                Remove-Item $Tempfile -Force
                Write-Host "FilDeleted Temp File $TempFile"
            }elif($file.LastWriteTime -lt $StateDate){
                Copy-Item $file -Destination $TempFile
                ($file.LastWriteTime).ToString() | sc $StateFile
                if($FormatIsUnicode -eq $true){
                    (get-content $TempFile -Encoding Unicode) -replace ".{200}" , "$&`r`n" | sc $OutputFile -Force
                }else{
                    (get-content $TempFile) -replace ".{200}" , "$&`r`n" | sc $OutputFile -Force
                }
                Write-Host "File Converted "$file.Name
                Remove-Item $Tempfile -Force
                Write-Host "FilDeleted Temp File $TempFile"
            }
        }else{
            Copy-Item $file -Destination $TempFile
            ($file.LastWriteTime).ToString() | sc $StateFile
            if($FormatIsUnicode -eq $true){
                (get-content $TempFile -Encoding Unicode) -replace ".{200}" , "$&`r`n" | sc $OutputFile -Force
            }else{
                (get-content $TempFile) -replace ".{200}" , "$&`r`n" | sc $OutputFile -Force
            }
            Write-Host "File Converted "$file.Name
            Remove-Item $Tempfile -Force
            Write-Host "FilDeleted Temp File $TempFile"
        }

    }       
}
exit 0
