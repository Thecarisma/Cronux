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
	# [System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
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