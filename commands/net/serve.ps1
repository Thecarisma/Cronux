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
    [string]$KillRoute = '/kill'
)

$Prefixes = New-Object System.Collections.ArrayList

Function main {
	Process-Folder-And-Address
	Start-Server
}

Function Process-Folder-And-Address {
	$Title = 'Ethernet'
	#$Prefixes.Add("http://localhost:$Port/") > $null
	#$Prefixes.Add("http://127.0.0.1:$Port/") > $null
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
		$Http
	)

	If ($http.IsListening) {
		Write-Host " HTTP Server Ready!  " -f 'black' -b 'gre'
		Write-Host "now try going to $($http.Prefixes)" -f 'y'
		Write-Host "then try going to $($http.Prefixes)other/path" -f 'y'
	}


	while ($http.IsListening) {
		$context = $http.GetContext()
		if ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl -eq $KillRoute) {
			Break
			
		} ElseIf ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl.StartsWith('/')) {
			[string]$html = "<h1>A Powershell Webserver</h1><p>home page</p>" 
			
			$buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
			$context.Response.ContentLength64 = $buffer.Length
			$context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
			$context.Response.OutputStream.Close()
			
		} Else {
			[string]$html = "Invalid route " 
			
			$buffer = [System.Text.Encoding]::UTF8.GetBytes($html) # convert htmtl to bytes
			$context.Response.ContentLength64 = $buffer.Length
			$context.Response.OutputStream.Write($buffer, 0, $buffer.Length) #stream to broswer
			$context.Response.OutputStream.Close()
		}

	} 
}

main

