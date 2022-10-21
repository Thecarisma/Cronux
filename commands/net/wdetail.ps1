<#
.SYNOPSIS
    View the full detail of a saved wifi networks
.DESCRIPTION
    View the full detail of a saved wifi networks 
    including the ssid and security detail.
    
    If no name given all the network will 
    be shown in a list and a specific 
    network can be choose with it index 
    
    It accept various flag to select which info 
    to show.
.INPUTS 
    System.String
.OUTPUTS 
    [System.String]
.NOTES
    Version    : 1.0
    File Name  : wdetail.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : May-20-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    wdetail
    List all the wifi networks that has been 
    connected to this PC and select which one 
    to display it full detail.
.EXAMPLE
    wdetail 'SMILE@THECARISMA'
    Show the detail of the wifi network which 
    it name equal or contains 'SMILE@THECARISMA' 
.EXAMPLE
    wdetail 'SMILE@THECARISMA' -Password
    Show only the password of the wifi 
    network which it name equal or contains 
    'SMILE@THECARISMA' 
#>

[CmdletBinding()]
Param(
    # the name of the wifi network to show 
    [string]$Name,
    # Show the wifi network password
    [switch]$Password,
    # Show the wifi network type
    [switch]$Type,
    # Show the wifi network version
    [switch]$Version,
    # Show the wifi network authentication 
    [switch]$Authentication,
    # Show the wifi network cipher
    [switch]$Cipher
)

Function main {
    If (-not $Name) {
        $Name = "All User Profile"
    }
    $Networks = Invoke-Netsh-Wlan
    $New_Name = ""
    If ($Networks.Length -eq 1) {
        $New_Name = $Networks[0]
        
    } ElseIf ($Networks.Length -gt 1) {
        $Index = 0
        ForEach ($Network in $Networks) {
            "$($Index): $($Network)"
            $Index++
        }
        $Loc = Read-Host 'Select a wifi network using it index number '
        $New_Name = $Networks[$Loc]
        If (-not $New_Name) {
            "Invalid index specified '$Loc'" | Write-Host -Fore red
            Return
        }
    } Else {
        "No wifi network found matching the name: '$Name'" | Write-Host -Fore red
        Return
    }
    Invoke-Netsh-Wlan-Single $New_Name
}

Function Invoke-Netsh-Wlan {
    $Networks = @()
    $(netsh wlan show profiles | findstr "$Name") | ForEach-Object {
        $_ = $_ -split (":")
        If ($_.Length -gt 1 -and $_[1].Trim() -ne "") {
            $Networks += $_[1].Trim()
        }
    }
    Return ,$Networks
}

Function Invoke-Netsh-Wlan-Single {
    Param(
        [string]$New_Name
    )
    
    If (-not $Password -and -not $Type -and -not $Version -and
        -not $Authentication -and -not $Cipher ) {
        
        netsh wlan show profile name="$New_Name" key=clear
        Return
    }
    $(netsh wlan show profile name="$New_Name" key=clear) | ForEach-Object {
        $Print = $False
        If ($Password -and $_.Contains("Key Content")) {
            $Print = $True
            $Password = $null
            
        } ElseIf ($Type -and $_.Contains("Type")) {
            $Print = $True
            $Type = $null
            
        } ElseIf ($Version -and $_.Contains("Version")) {
            $Print = $True
            $Version = $null
            
        } ElseIf ($Authentication -and $_.Contains("Authentication")) {
            $Print = $True
            $Authentication = $null
            
        } ElseIf ($Cipher -and $_.Contains("Cipher")) {
            $Print = $True
            $Cipher = $null
            
        }
        If ($Print -eq $True) {
            $_ = ($_ -split (":"))[1].Trim()
            $_
        }
    }
}

main

























