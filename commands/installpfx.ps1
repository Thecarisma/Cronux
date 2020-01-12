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
    Date       : Jan-09-2019
.LINK
    https://thecarisma.github.io/Cronux
    https://dev.to/iamthecarisma/managing-certificates-through-powershell-2ok0
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

$password = ConvertTo-SecureString -String $password_ -Force -AsPlainText
$cert_path = [System.IO.Path]::GetFullPath($cert_path)

If ( -not [System.IO.File]::Exists($cert_path)) {
    Write-Error "$cert_path does not exist"
    Return
}

Import-PfxCertificate -FilePath "$cert_path" -CertStoreLocation Cert:\LocalMachine\My -Password $password
