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
    CodeSigningCert
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
    [string]$type,
    [Parameter(mandatory=$true)]
    [string]$output_folder_path,
    [switch]$DontRemove
)

$store_location = "Cert:\LocalMachine\My"
$expiry_year = (Get-Date).AddYears($expiry_year_)
$output_folder_path = [System.IO.Path]::GetFullPath($output_folder_path)

If ( -not [System.IO.Directory]::Exists($output_folder_path)) {
    [System.IO.Directory]::CreateDirectory($output_folder_path) > $null
    If ( -not $?) {
        Return
    }
}

Function Find-Delete-Certificate {
    Param([string]$cert_subject_name)

    ForEach ($cert in (ls "$store_location")) {
        If ($cert.Subject -eq "CN=$cert_subject_name") {
            "Removing already existing certificate $store_location\My"
            $cert | Remove-Item
            If ( -not $?) {
                Return
            }
        }
    }
}

Find-Delete-Certificate $cert_name
"Generating and installing certificate"
$cert = New-SelfSignedCertificate -Subject $cert_name -notafter $expiry_year -Type $type -CertStoreLocation $store_location
"Exporting the certificate to $output_folder_path\$cert_name.cer"
Export-Certificate -FilePath "$output_folder_path\$cert_name.cer" -Cert $cert
If ( -not $DontRemove) {
    Find-Delete-Certificate $cert_name
}