<#
.SYNOPSIS
   Serve a folder over the network with a specific port
.DESCRIPTION
    Serve a folder under all the available IPv4 address on your
	system, (Ethernet, Wireless, LAN, WAN, Local Host e.t.c), 
	with a specific port. 
	
	It impossible to kill the server while it running except 
	by visiting the kill route which is /kill by default 
	Use the -KillRoute to specify a custom kill route
.INPUTS 
    System.Int32
    System.String
    System.String
    System.Int32
	Switch
	Switch
.OUTPUTS 
    [System.String[]]
.NOTES
    Version    : 1.0
    File Name  : serve.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : April-04-2021
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    serve 2000 C:/folder
    Serve the folder 'C:/folder' over the port 2000 on all the 
	IPv4 address including localhost:2000 and 127.0.0.1:2000.
	
	If a file name index.html is in the folder C:/folder it is 
	served instead of listing the files and folders.
.EXAMPLE
    serve 2000 C:/folder -NoIndex
    Serve the folder 'C:/folder' over the port 2000 on all the 
	IPv4 address including localhost:2000 and 127.0.0.1:2000
	
	If index.html is in the folder C:/folder it is ignored and 
	the files and folders are listed
.EXAMPLE
    serve 2000 C:/folder -KillRoute jwyqsahsjh
    Serve the folder 'C:/folder' over the port 2000 on all the 
	IPv4 address including localhost:2000 and 127.0.0.1:2000.
	
	Since using Ctrl+C does not shutdown the server, visiting the 
	address with the route /jwyqsahsjh e.g. 127.0.0.1:2000/jwyqsahsjh 
	will kill the server
.EXAMPLE
    serve 2000 C:/folder -WirelessOnly
    Serve the folder 'C:/folder' over the port 2000 on only
	Wireless LAN and WAN IPv4 addresses only including localhost:2000 
	and 127.0.0.1:2000, ethernet and other network IPv4 addresses are 
	ignored
#>

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

