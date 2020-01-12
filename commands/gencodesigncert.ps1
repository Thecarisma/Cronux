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
$store_location = "Cert:\LocalMachine"
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

    ForEach ($cert in (ls "$store_location\My")) {
        If ($cert.Subject -eq "CN=$cert_subject_name") {
            "Removing already existing certificate $store_location\My"
            $cert | Remove-Item
            If ( -not $?) {
                Return
            }
        }
    }
    ForEach ($cert in (ls "$store_location\Root")) {
        If ($cert.Subject -eq "CN=$cert_subject_name") {
            "Removing already existing certificate in $store_location\Root"
            $cert | Remove-Item
            If ( -not $?) {
                Return
            }
        }
    }
}

Find-Delete-Certificate $cert_name
"Generating and installing certificate"
$cert = New-SelfSignedCertificate -Subject "$cert_name" -notafter $expiry_year -Type CodeSigningCert -CertStoreLocation "$store_location\My"
"Exporting the certificate to $output_folder_path\$cert_name.pfx"
Export-PfxCertificate -Cert "$store_location\My\$($cert.Thumbprint)" -FilePath "$output_folder_path\$cert_name.pfx" -Password $password
Find-Delete-Certificate $cert_name