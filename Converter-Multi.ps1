param(
    [Boolean]$FormatIsUnicode = $true,
    [String]$BasePath = "D:\SAP Logs"
)

trap [Exception] 
{
       write-error $("Exception: " + $_)
       exit 1
}

$LogPaths = @{
    "SRv1" = "\\Srv1\log" ; 
    "Srv2" = "\\Srv2\log";
    "SRv3" = "\\Srv3\log"
}

Function Convert-File{
    param(
        [String]$SrcPath,
        $DstPath,
        $OutFile,
        $StatePath,
        [Boolean]$FormatUnicode
    )
    $SrcFile = Get-ChildItem -Path $SrcPath
    Copy-Item $SrcPath -Destination $DstPath
    $SrcFile.LastWriteTime.Ticks | Set-Content $StatePath -NoNewline
    if($FormatUnicode -eq $true){
        (get-content $DstPath -Encoding Unicode) -replace ".{200}" , "$&`r`n" | Set-Content $OutputFile -Force
    }else{
        (get-content $DstPath) -replace ".{200}" , "$&`r`n" | Set-Content $OutFile -Force
    }
    Write-Host "File Converted "$SrcFile.Name
    Remove-Item $DstPath -Force
    Write-Host "FilDe Temp File $DstPath"
}


$LogPaths.getEnumerator() | %{
    $SrvBasePath = "$BasePath\$($_.key)"
    if(!(Test-Path -Path $SrvBasePath)){
        New-Item -Path $SrvBasePath -ItemType Directory
    }
    $StatePath = "$SrvBasePath\state"
    if(!(Test-Path -Path $StatePath)){
        New-Item -Path $StatePath -ItemType Directory
    }
    $AuditFiles = Get-ChildItem "$($_.Value)\*.AUD"
    Foreach ($file in $AuditFiles){
        $StateFile = "$StatePath\$($file.BaseName).st"
        $TempFile = "$SrvBasePath\$($file.Name)"
        $OutputFile = "$SrvBasePath\$($file.BaseName).log"
                
        if(Test-Path -Path $StateFile){
            $StateTicks = [double](Get-Content -Path $StateFile)
            
            if($file.LastWriteTime.Ticks -ne $StateTicks){
                Convert-File -SrcPath $file.FullName -DstPath $TempFile -OutFile $OutputFile -StatePath $StateFile -FormatUnicode $FormatIsUnicode
            }else{
                Write-Host "Skipping File $($file.Name)"
            }
        }else{
            Convert-File -SrcPath $file.FullName -DstPath $TempFile -OutFile $OutputFile -StatePath $StateFile -FormatUnicode $FormatIsUnicode
        }
    }       
}
exit 0 
