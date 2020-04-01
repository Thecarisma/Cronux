<#
.SYNOPSIS
    Convert string to base64
.DESCRIPTION
    Convert a string to it base64 value, write the base64 
    result into a file, copy it to clipboard or generates 
    a valid JSON Object. 
.INPUTS 
    The string to get it base64 value
.OUTPUTS 
    Depends on switches
.NOTES
    Version    : 1.0
    File Name  : base64.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : 2020
.LINK
    https://thecarisma.github.io/Cronux
    https://philipm.at/2018/base64_in_powershell.html
    https://www.reddit.com/r/PowerShell/comments/800jnc/converttobase64_encodes_files_to_base64/
.EXAMPLE
    base64 "Normal String here" -WriteToFile
    The command encodes the string in base64 and writes it 
    to file 'str.base64' in working directory where this 
    script was executed
.EXAMPLE
    base64s "Normal String here" -AndCopyToClipboard
    The command encodes the string in base64 and copies the 
    base64 value to clipboard  
.EXAMPLE
    base64 "Normal String here" -ToJson
    The command encodes the string in base64 and generates a 
    valid JSON object of the base64 value
    
#>

[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True, Position=0)]
	[string]$InputString,

	[switch]$ToJson,
	[switch]$AndCopyToClipboard,
	[switch]$WriteToFile
)

$base64String = [System.Convert]::ToBase64String([system.Text.Encoding]::UTF8.GetBytes($InputString))
if ($ToJson) {
	Add-Type -AssemblyName System.Web.Extensions
	$jsonSerializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer 
	$base64String = $jsonSerializer.Serialize(@{ content = $base64String })
}

if ($WriteToFile) {
	$outFile = if ($ToJson) { "str.json" } else { "$str.base64" }

	[System.IO.File]::WriteAllText($outFile, $base64String)
	Write-Host -NoNewline "Wrote to file: " 
	Write-Host -ForegroundColor Green $outFile
} else {
	Write-Output -InputObject $base64String
}

if ($AndCopyToClipboard) {
	Add-Type -AssemblyName System.Windows.Forms
	[System.Windows.Forms.Clipboard]::SetText($base64String);
}