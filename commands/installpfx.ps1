<#
.SYNOPSIS
    
.DESCRIPTION
    
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
.EXAMPLE
    installpfx ./dist/Cronux.pfx mypassword Cert:\LocalMachine\My
.EXAMPLE
    installpfx 'My Code Signer' 1 ./dist/ mypassword
    This generates the Cronux certificate in 'cert:\LocalMachine\Root' 
    and exports Cronux.pfx to ./dist/ folder. The generated certificate 
    expires after 1 years.
    
#>

Param(
    [Parameter(mandatory=$true)]
    [string]$cert_path,
    [Parameter(mandatory=$true)]
    $password_
)

$password = ConvertTo-SecureString -String "mypassword" -Force -AsPlainText
$cert_path = [System.IO.Path]::GetFullPath($cert_path)

If ( -not [System.IO.File]::Exists($cert_path)) {
    Write-Error "$cert_path does not exist"
    Return
}

Import-PfxCertificate -FilePath "$cert_path" -CertStoreLocation Cert:\LocalMachine\My -Password $password
