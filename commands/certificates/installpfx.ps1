<#
.SYNOPSIS
    Install a pfx certificate into Cert:\LocalMachine\Root store.
.DESCRIPTION
    Install a pfx certificate into Cert:\LocalMachine\Root store. This 
    command is a shorthand for using `installpfxx` to install into the 
    Cert:\LocalMachine\Root store. 
    
    The pfx certificate is installed into the system trusted location.
    Only the pfx certificate location and password is required and this 
    does not prompt a confirm dialog.  
.INPUTS 
    System.String[]
.OUTPUTS 
    System.String
.NOTES
    Version    : 1.0
    File Name  : installpfx.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-09-2020
.LINK
    https://thecarisma.github.io/Cronux
    https://dev.to/iamthecarisma/managing-certificates-through-powershell-2ok0
    https://docs.microsoft.com/en-us/windows/win32/seccrypto/system-store-locations
    https://docs.microsoft.com/en-us/windows/win32/seccrypto/digital-certificates
.EXAMPLE
    installpfx ./Certificate.pfx password
    Install the pfx Certificate into the system trusted location Cert:\LocalMachine\Root
.EXAMPLE
    installpfx ./Certificate2.pfx youshallnotpass
    Install the pfx Certificate2 into the system trusted location Cert:\LocalMachine\Root
    
#>

Param(
    [Parameter(mandatory=$true)]
    [string]$cert_path,
    [Parameter(mandatory=$true)]
    $password_
)

iex "$PSScriptRoot\installpfxx.ps1 $cert_path $password_ Cert:\LocalMachine\Root"
