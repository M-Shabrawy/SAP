param(
    [Binary]$FormatIsUnicode = $false,
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
$LogPaths = @(
        "\\srv1\log",
        "\\srv2\log",
        "\\srv3\log"
    )

foreach($LogPath in $LogPaths){
    $AuditFiles = Get-ChildItem "$LogPath\*.AUD"
    Foreach ($file in $AuditFiles){
        $StateFile = "$StatePath\$($file.BaseName).st"
        $TempFile = "$TempPath\$($file.Name)"
        $OutputFile = "$TempPath\$($file.BaseName).log"
                
        if(Test-Path -Path $StateFile){
            $StateDate = [datetime]::ParseExact((Get-Content -Path $StateFile),"yyyy/MM/dd hh:mm:ss",$null)
            if($file.LastWriteTime -gt $StateDate){
                Copy-Item $file -Destination $TempFile
                ($file.LastWriteTime).ToString() | sc $StateFile
                (get-content $TempFile) -replace ".{200}" , "$&`r`n" | sc $OutputFile -Force
                Write-Host "File Converted "$file.Name
                Remove-Item $Tempfile -Force
                Write-Host "FilDeleted Temp File $TempFile"
            }
        }else{
            Copy-Item $file -Destination $TempFile
            ($file.LastWriteTime).ToString() | sc $StateFile
            (get-content $TempFile) -replace ".{200}" , "$&`r`n" | sc $OutputFile -Force
            Write-Host "File Converted "$file.Name
            Remove-Item $Tempfile -Force
            Write-Host "FilDeleted Temp File $TempFile"
        }

    }       
}
exit 0
