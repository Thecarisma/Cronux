<#
.SYNOPSIS
    
.DESCRIPTION
    
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
.EXAMPLE
    installpfx ./Certificate.pfx password
.EXAMPLE
    installpfx ./Certificate.pfx password Cert:\LocalMachine\My
.EXAMPLE
    installpfx ./Certificate.pfx password Cert:\LocalMachine\Root
    
#>

Param(
    [Parameter(mandatory=$true)]
    [string]$cert_path,
    [Parameter(mandatory=$true)]
    $password_,
    [Parameter(mandatory=$false)]
    $password_
)

$password = ConvertTo-SecureString -String "mypassword" -Force -AsPlainText
$cert_path = [System.IO.Path]::GetFullPath($cert_path)

If ( -not [System.IO.File]::Exists($cert_path)) {
    Write-Error "$cert_path does not exist"
    Return
}

Import-PfxCertificate -FilePath "$cert_path" -CertStoreLocation Cert:\LocalMachine\My -Password $password
