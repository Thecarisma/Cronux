<#
.SYNOPSIS
    
.DESCRIPTION
    
.INPUTS 
    
.OUTPUTS 
    
.NOTES
    File Name  : ps12bat.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-06-2019
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    
.EXAMPLE
    
#>

Param(
    [parameter(ValueFromRemainingArguments = $true)]
    [string[]]$args
)
  
$ad = "$args"  
$lines = $ad.Split("`n")
$length = 0
ForEach ($line in $lines) {
    If ($line.length -gt $length - 2) {
        $length = $line.length + 2
    }
}
$i = $length
While (--$i -gt 0) {
    Write-Host -NoNewline  "=" 
}
""
$ad
While (++$i -lt $length) {
    Write-Host -NoNewline  "=" 
}
""

Param(
    [string]$batch_path,
    [string]$embed,
    
)
git add .
git commit -m "$args"
git push origin HEAD