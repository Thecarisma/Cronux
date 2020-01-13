<#
.SYNOPSIS
    Generate a secure code signing certificate.
.DESCRIPTION
    Generate a code signing certificate to sign your application, 
    powershell script e.t.c. After generating the certificate, 
    it is exported into the output folder specified in the third parameter. 
    
    If a certificate already exist with the same Subject name the old 
    certificate is removed and replaced with the new certificate that 
    is generated.
.INPUTS 
    System.String System.int32 System.String System.String
.OUTPUTS 
    System.String
.NOTES
    Version    : 1.0
    File Name  : gencodesigncert.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-09-2019
.LINK
    https://thecarisma.github.io/Cronux
    https://dev.to/iamthecarisma/managing-certificates-through-powershell-2ok0
    https://docs.microsoft.com/en-us/windows/win32/seccrypto/system-store-locations
    https://docs.microsoft.com/en-us/windows/win32/seccrypto/digital-certificates
.EXAMPLE
    gencodesigncert 'Cronux' 3 ./dist/ mypassword
    This generates the Cronux certificate in 'cert:\LocalMachine\My' 
    and exports Cronux.pfx to ./dist/ folder. The generated certificate 
    expires after 3 years.
.EXAMPLE
    gencodesigncert 'My Code Signer' 1 ./dist/ mypassword
    This generates the Cronux certificate in 'cert:\LocalMachine\My' 
    and exports Cronux.pfx to ./dist/ folder. The generated certificate 
    expires after 1 years.
    
#>

Param(
    [Parameter(mandatory=$true)]
    [string]$cert_name,
    [Parameter(mandatory=$true)]
    [int]$expiry_year_,
    [Parameter(mandatory=$true)]
    [string]$output_folder_path,
    [Parameter(mandatory=$true)]
    [string]$password_
)

$password = ConvertTo-SecureString -String $password_ -Force -AsPlainText

$cert = iex "$PSScriptRoot\gencert.ps1 $cert_name $expiry_year_ CodeSigningCert $output_folder_path -DontExport"
Export-PfxCertificate -Cert "Cert:\LocalMachine\My\$($cert.Thumbprint)" -FilePath "$output_folder_path\$cert_name.pfx" -Password $password
iex "$PSScriptRoot\delcert.ps1 $cert_name"