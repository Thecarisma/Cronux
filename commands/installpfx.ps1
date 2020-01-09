<#
.SYNOPSIS
    Generate a code signing certificate.
.DESCRIPTION
    Generate a code signing certificate to sign your application, 
    powershell script e.t.c. The certificate is generated into the 
    'cert:\LocalMachine\My' certificate store location and moved to 
    and moved to 'Cert:\LocalMachine\Root' to mark it as a trusted 
    certificate. Always put the first argument which is the name of 
    the certificate in a single quote e.g. `'Cronux Certificate'`.
    
    After generating the certificate, it is exported into the output 
    folder specified in the third parameter. 
    
    If a certificate already exist with the same Subject name the old 
    certificate is removed and replaced with the new certificate that 
    is generated.
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
    installpfx 'Cronux' 3 ./dist/ mypasssword
    This generates the Cronux certificate in 'cert:\LocalMachine\My' 
    and exports Cronux.pfx to ./dist/ folder. The generated certificate 
    expires after 3 years.
.EXAMPLE
    installpfx 'My Code Signer' 1 ./dist/ mypasssword
    This generates the Cronux certificate in 'cert:\LocalMachine\My' 
    and exports Cronux.pfx to ./dist/ folder. The generated certificate 
    expires after 1 years.
    
#>

Param(
    [Parameter(mandatory=$true)]
    [string]$cert_path,
    [Parameter(mandatory=$true)]
    [string]$password_
)

$password = ConvertTo-SecureString -String "mypasssword" -Force -AsPlainText
$cert_path = [System.IO.Path]::GetFullPath($cert_path)

If ( -not [System.IO.File]::Exists($cert_path)) {
    Write-Error "$cert_path does not exist"
    Return
}

Import-PfxCertificate -FilePath "$cert_path" -CertStoreLocation Cert:\LocalMachine\Root -Password $password
