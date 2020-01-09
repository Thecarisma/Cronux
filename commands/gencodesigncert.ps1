<#
.SYNOPSIS
    Generate a code signing certificate.
.DESCRIPTION
    Generate a code signing certificate to sign your application, 
    powershell script e.t.c. The certificate is generated into the 
    'cert:\LocalMachine\My' certificate store location and moved to 
    and moved to 'Cert:\LocalMachine\Root' to mark it as a trusted 
    certificate. 
    
    Aftet generating the certificate, it is exported into the output 
    folder specified in the third parameter. 
    
    Always put the first argument which is the name of the certificate 
    in a single quote e.g. `'Cronux Certificate'`.
.INPUTS 
    System.String[]
.OUTPUTS 
    System.String
.NOTES
    Version    : 1.0
    File Name  : gencodesigncert.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-09-2019
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    gencodesigncert 'Cronux' 3 ./dist/
    This generates the Cronux certificate in 'cert:\LocalMachine\My' 
    and exports Cronux.pfx to ./dist/ folder. The generated certificate 
    expires after 3 years.
.EXAMPLE
    gencodesigncert 'My Code Signer' 1 ./dist/
    This generates the Cronux certificate in 'cert:\LocalMachine\My' 
    and exports Cronux.pfx to ./dist/ folder. The generated certificate 
    expires after 1 years.
    
#>

Param(
    [Parameter(mandatory=$true)]
    [string]$cert_name,
    [Parameter(mandatory=$true)]
    [int]$expiry_year,
    [Parameter(mandatory=$true)]
    [string]$output_folder_path
)

$cert_name
$expiry_year
$output_folder_path

#$cert = New-SelfSignedCertificate -Subject "$cert_name" -Type CodeSigningCert -CertStoreLocation cert:\LocalMachine\My