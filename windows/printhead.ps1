

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