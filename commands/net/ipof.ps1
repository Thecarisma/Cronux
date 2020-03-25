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
    [string]$URL
)

if ($URL.Contains("://")) {
    $index = $URL.IndexOf("://") + 3
    $URL = $URL.SubString($index, $URL.Length - $index) 
}
[System.Net.Dns]::GetHostAddresses($URL) | foreach {$_.IPAddressToString }