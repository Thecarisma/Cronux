<#
.SYNOPSIS
    Install a pfx certificate to specified location.
.DESCRIPTION
    Install a pfx certificate to a specified store location on the system. 
    PFX certificate is expected to have a password hence the password should 
    be specified as the second parameter and the store location as the store 
    location.
    
    The third parameter `$store_location` is not mandatory. 
    
    If the store location is not specified the pfx certificate is installed 
    into Cert:\CurrentUser\My store which wioll make the certificate untrusted.
.INPUTS 
    System.String[]
.OUTPUTS 
    System.String
.NOTES
    Version    : 1.0
    File Name  : installpfxx.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-12-2019
.LINK
    https://thecarisma.github.io/Cronux
    https://dev.to/iamthecarisma/managing-certificates-through-powershell-2ok0
.EXAMPLE
    installpfx ./Certificate.pfx password
    If the location store to install the certificate to is not specified 
    the pfx certificate is installed into the Cert:\CurrentUser\My store 
    which makes the certificate untrusted.
.EXAMPLE
    installpfx ./Certificate.pfx password Cert:\CurrentUser\Root
    Install the pfx certificate into the Cert:\CurrentUser\Root store 
    location which is a path for secure certificate for the current user.
.EXAMPLE
    installpfx ./Certificate.pfx password Cert:\LocalMachine\Root
    Install the pfx certificate into the Cert:\LocalMachine\Root store 
    location which is a path for secure certificate for computer.
    
#>

Param(
    [Parameter(mandatory=$true)]
    [string]$cert_path,
    [Parameter(mandatory=$true)]
    $password_,
    [Parameter(mandatory=$false)]
    $store_location
)

If (-not $store_location) {
    $store_location = "Cert:\LocalMachine\My"
}
$password = ConvertTo-SecureString -String $password_ -Force -AsPlainText
$cert_path = [System.IO.Path]::GetFullPath($cert_path)

If ( -not [System.IO.File]::Exists($cert_path)) {
    Write-Error "$cert_path does not exist"
    Return
}

Import-PfxCertificate -FilePath "$cert_path" -CertStoreLocation $store_location -Password $password
