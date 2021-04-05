<#
.SYNOPSIS
   List the ip addresses of a url
.DESCRIPTION
    List all the host addresses of a particular url.
    Internet connection is required to fetch the ip 
    addresses.
.INPUTS 
    System.String
.OUTPUTS 
    [System.String]
.NOTES
    Version    : 1.0
    File Name  : ipof.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : March-25-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    ipof google.com
    List all the ip addresses of Google url 
.EXAMPLE
    ipof https://www.github.com
    List all the ip addresses of Github
#>

# This is a super **SIMPLE** example of how to create a very basic powershell webserver
# 2019-05-18 UPDATE — Created by me and and evalued by @jakobii and the comunity.

# Get Request Url
# When a request is made in a web browser the GetContext() method will return a request object
# Our route examples below will use the request object properties to decide how to respond
# Http Server

[CmdletBinding()]
Param(
    # The port to serve the folder on 
    [Parameter(Mandatory=$true)]
    [int]$Port,
    # The folder to serve 
    [Parameter(Mandatory=$true)]
    [string]$Folder,
    # The route to use for killing the server
    [string]$KillRoute = '/kill',
    # The default buffer size
	$BuffSize = 256mb,
    # If specified do not send index.html for a folder
	[switch]$NoIndex,
    # Serve on onle Wireless LAN/WAN IPv4 Addresses
	[switch]$WirelessOnly
)

$Prefixes = New-Object System.Collections.ArrayList
$Folder = [System.IO.Path]::GetFullPath($Folder)

Function main {
	Process-Folder-And-Address
}

Function Process-Folder-And-Address {
	If ( -not [System.IO.Directory]::Exists($Folder)) {
		Write-Error "The folder $Folder does not exist..."
		Return
	}
	
	$Title = 'Ethernet'
	$Prefixes.Add("http://localhost:$Port/") > $null
	$Prefixes.Add("http://127.0.0.1:$Port/") > $null
	If ($WirelessOnly) {
		$(ipconfig) | ForEach-Object {
			$Line = $_
			If (-not $Line.StartsWith(" ") -and $Line.Trim() -ne '') {
				$Title = $Line
			}
			If ($Line.Contains('IPv4') -and ($Title.Contains('Wireless') -or $Title.Contains('LAN'))) {
				$Line = $_
				$IP = $_.Split(' ')
				If ($IP.Length -gt 0) {
					$IP = $IP[$IP.Length - 1].Trim()
					$Prefixes.Add("http://$($IP):$Port/") > $null
					Return
				}
			}		
		}
	} Else {
		$(ipconfig | findstr 'IPv4') | ForEach-Object {
			$IP = $_.Split(' ')
			if ($IP.Length -gt 0) {
				$IP = $IP[$IP.Length - 1].Trim()
				$Prefixes.Add("http://$($IP):$Port/") > $null
			}
		}
	}
	Start-Server	
}

Function Start-Server {
	$http = [System.Net.HttpListener]::new()
	ForEach ($Prefix in $Prefixes) {
		Write-Verbose "Adding the base prefix address $Prefix "
		$http.Prefixes.Add($Prefix)
	}
	$http.Start()
	Run-Request-Loop $http
}

Function Run-Request-Loop {
	Param(
		$http
	)

	If ($http.IsListening) {
		Write-Host "HTTP Server Runnning!  " -f 'black' -b 'gre'
	} Else {
		Stop-Server $http
		Return
	}


	while ($http.IsListening) {
		$context = $http.GetContext()
		if ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl -eq $KillRoute) {
			Send-Html $context "<h1>Server killed...</h1>"
			Stop-Server $http
			Break
			
		} ElseIf ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl.StartsWith('/')) {
			$Path = [System.IO.Path]::GetFullPath("$Folder/$($context.Request.RawUrl)")
			$PathCut = $Path.Replace($Folder, '')
			If (-not ($Path | Test-Path)) {
				Send-Html $context "<h1>The file or folder $($context.Request.RawUrl) does not exist...</h1>"
				Continue
			}
			If (Test-Path -Path $Path -PathType Leaf) {
				Send-File $context $Path
			} else {
				$html = ""
				Get-ChildItem $Path -Name | ForEach-Object {
					$Name = $_
					$Link = "http://" + $context.Request.LocalEndPoint.ToString() + "$PathCut/$Name"
					$html += "<br/><a href=`"$Link`">$($_)</a>"
					If ($Name -eq "index.html" -and -not $NoIndex) {
						Send-File $context ($Path + "/" + $Name)
						Continue
					}
				}
				Send-Html $context $html
			}
			Write-Verbose "Served $Path to $($context.Request.RemoteEndPoint.ToString())... "
			
		} Else {
			[string]$html = "Invalid route" 
			
			$buffer = [System.Text.Encoding]::UTF8.GetBytes($html) # convert htmtl to bytes
			$context.Response.ContentLength64 = $buffer.Length
			$context.Response.OutputStream.Write($buffer, 0, $buffer.Length) #stream to broswer
			$context.Response.OutputStream.Close()
		}

	} 
}

Function Stop-Server {
	Param(
		$http
	)
	
	$http.Stop()	
}

Function Send-File {
	Param(
		$context,
		$Path
	)
	
	$fileStream = [System.IO.File]::OpenRead($Path)
	$chunk = New-Object byte[] $BuffSize

	While ($bytesRead = $fileStream.Read($chunk, 0, $BuffSize) ){
		$context.Response.OutputStream.write($chunk, 0, $bytesRead)
		$context.Response.OutputStream.Flush()
	}

	$fileStream.Close()
	$context.Response.OutputStream.Close()
}

Function Send-Html {
	Param(
		$context,
		$html
	)
	
	$buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
	$context.Response.ContentLength64 = $buffer.Length
	$context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
	$context.Response.OutputStream.Close()
}

main

