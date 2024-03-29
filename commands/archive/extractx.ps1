<#
.SYNOPSIS
    
.DESCRIPTION
    Only Alias and Application is exported
.INPUTS 
    
.OUTPUTS 
    
.NOTES
    Version    : 1.0
    File Name  : extractx.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : Jan-06-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    extractx ./ExportList.txt
    
.EXAMPLE
    
#>

Param(
    [Parameter(mandatory=$true)]
    [string]$export_list_path,
    [switch]$Application
)

$export_list_path = [System.IO.Path]::GetFullPath($export_list_path)
$export_list_path_dir = [System.IO.Path]::GetDirectoryName($export_list_path)
$count = 0

If ( -not [System.IO.Directory]::Exists($export_list_path_dir)) {
    [System.IO.Directory]::CreateDirectory($export_list_path_dir) > $null
    If ( -not $?) {
        Return
    }
}
"Preparing to export commands to $export_list_path"
[System.IO.File]::WriteAllLines("$export_list_path", 
"//All the Alias, Functions, Cmdlets preinstalled or exposed 
//through powershell. This is autogenerated by Cronux 
//<https://thecarisma.github.io/Cronux>
")

Get-Command * | ? { $_.CommandType -eq "Alias" -or ($Application -and $_.CommandType -eq "Application")} | Foreach-Object {
    If (-not $_.Name.Contains("\") -and -not $_.Name.Contains("/") -and -not $_.Name.Contains(":") -and -not $_.Name.Contains("*") -and -not $_.Name.Contains("?") -and -not $_.Name.Contains("`"") -and -not $_.Name.Contains("<") -and -not $_.Name.Contains(">") -and  -not $_.Name.Contains("|")) {
        [System.IO.File]::AppendAllText("$export_list_path", "$($_.Name)`n")
        $count++
    }
}
"$count commands exported into $export_list_path"