<#
.SYNOPSIS
    Prints a sentence with a line printed at the top and bottom
.DESCRIPTION
    Prints a sentence with line printed at the top before the sentence 
    and below the sentence. This script does not help in breaking 
    a long sentence, a long sentence should be escaped using the 
    powershell escape characters which starts with '`' e.g for a newline 
    break '`n'.
    
    The lines printed is one character longer than the length of 
    the longest sentence in a single line.
.INPUTS 
    System.String[]
.OUTPUTS 
    The sentence with line printed above and below it
.NOTES
    File Name  : printhead.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-07-2019
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    printhead this is a sentence
    the output of the command is 
    ===================
    this is a sentence
    ===================
.EXAMPLE
    printhead this is a very very `nlong line I can see that
    the output of the command is 
    =========================
    this is a very very 
    long line I can see that
    =========================
    Notice that the length of the lines is one character longer 
    that the second sentence which is the longest
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