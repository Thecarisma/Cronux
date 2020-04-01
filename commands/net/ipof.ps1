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
    Date       : March-25-2019
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    ipof google.com
    List all the ip addresses of Google url 
.EXAMPLE
    ipof https://www.github.com
    List all the ip addresses of Github
#>

[CmdletBinding()]
Param(
    #the url to fetch it ip addresses
    [string]$URL,
    # Use the Invoke-WebRequest with Method HEAD to find Ip
    [switch]$Head
)

Function main {
    if ($URL.Contains("://")) {
        $index = $URL.IndexOf("://") + 3
        $URL = $URL.SubString($index, $URL.Length - $index) 
    }
    if ($Head) {
        Invoke-WebRequest-Head
    } else {
        Try {
            [System.Net.Dns]::GetHostAddresses($URL) | foreach {$_.IPAddressToString }
        } catch {
            Invoke-WebRequest-Head
        }
    }
}

Function Invoke-WebRequest-Head {
    #for internal or url with no dns registered
    $(Invoke-WebRequest $URL -Method HEAD  | Select-Object -Expand Headers) | foreach {
        foreach ($Key in $_.Keys) {
            $Line = $_[$Key]
            if ($Line.Contains(":")) {
                $Line = $Line.Split(":")[0]
            }
            $Splited = $Line.Split(".")
            $IsIP = $False
            If ($Splited.Length -gt 3) {
                $IsIP = $True
                For ($i = 0; $i -lt 4 -and $IsIP; $i++) {
                    try {
                        $x = [convert]::ToInt32($Splited[$i], 10)
                    } catch {
                        $IsIP = $False
                    }
                }
            }
            If ($IsIP) {
                $Line
            }
        }
    }
}

main