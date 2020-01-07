
$annoyance = "if you've benefited from this project, consider supporting `nme on Patreon https://patreon.com/thecarisma"
$command_folder = "./"
$Global:found_command = $false

Function main {
    Print-Advert $annoyance
    Execute-Command $args
    Print-Advert $annoyance
}

Function Execute-Command {   
    $params = $args[0][0]
    $command, $sub_params = $params
    Iterate-Folder $command_folder $command $sub_params
    If ($Global:found_command -eq $false) {
        iex "$command $sub_params"
    }
}

Function Iterate-Folder {
    Param([string]$foldername, $command, $params)
    
    Get-ChildItem $foldername | Where-Object {$Global:found_command -eq $false} | Foreach-Object {
        If ( -not $_.PSIsContainer) {
            #$content = Get-Content $_.FullName
            If ( -not $_.Name.EndsWith(".ps1")) {
                Return
            }
            $NameOnly = $_.Name.Substring(0, $_.Name.LastIndexOf("."))
            If ($NameOnly -eq $command) {
                powershell $_.FullName $params
                $Global:found_command = $true
                Return
            }
        } Else {
            Iterate-Folder $_.FullName $command $params
        }
    }
    if ($Global:found_command -ne $true) {
        $Global:found_command = $false
    }
}

Function Print-Advert {
    Param([string]$ad)
    
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
}

main $args