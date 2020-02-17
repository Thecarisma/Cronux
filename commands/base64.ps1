<#
.SYNOPSIS
    Convert file to base64
.DESCRIPTION
    Convert a file to it base64 value, write the base64 
    result into a file, copy it to clipboard or generates 
    a valid JSON Object. 
.INPUTS 
    The path to file to get it base64 value
.OUTPUTS 
    Depends on switches
.NOTES
    Version    : 1.0
    File Name  : base64.ps1
    Author     : Philip Mateescu - https://www.reddit.com/user/philipmat/
    Date       : 2019
.LINK
    https://thecarisma.github.io/Cronux
    https://philipm.at/2018/base64_in_powershell.html
    https://www.reddit.com/r/PowerShell/comments/800jnc/converttobase64_encodes_files_to_base64/
.EXAMPLE
    base64 C:/path/to/file.extension -WriteToFile
    The command encodes the file in base64 and writes it 
    to file in the same directory as the file with the 
    extension '.base64' 
.EXAMPLE
    base64 C:/path/to/file.extension -AndCopyToClipboard
    The command encodes the file in base64 and copies the 
    base64 value to clipboard  
.EXAMPLE
    base64 C:/path/to/file.extension -ToJson
    The command encodes the file in base64 and generates a 
    valid JSON object of the base64 value
    
#>

[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True, Position=0)]
	[string]$InputFile,

	[switch]$ToJson,
	[switch]$AndCopyToClipboard,
	[switch]$WriteToFile
)


if ((Test-Path $InputFile) -eq $false) {
	Write-Host "Couldn't find file: $InputFile"
	exit 1
}

$base64String = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($InputFile))
if ($ToJson) {
	Add-Type -AssemblyName System.Web.Extensions
	$jsonSerializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer 
	$base64String = $jsonSerializer.Serialize(@{ content = $base64String })
}

if ($WriteToFile) {
	$outFile = if ($ToJson) { "${InputFile}.json" } else { "${InputFile}.base64" }

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