
$annoyance = "if you've benefited from this project, consider supporting `nme on Patreon https://patreon.com/thecarisma"
$command_folder = "./commands/"

Function main {
    Print-Advert $annoyance
    Execute-Command $args
    Print-Advert $annoyance
}

Function Execute-Command {   
    $params = $args[0][0]
    Iterate-Folder $command_folder $params
    
}

Function Iterate-Folder {
    Param([string]$foldername, $params)
    $first, $sub_params = $params
    
    Get-ChildItem $foldername | Foreach-Object {
        if ( -not $_.PSIsContainer) {
            #$content = Get-Content $_.FullName
            $NameOnly = $_.Name.Substring(0, $_.Name.LastIndexOf("."))
            if ($NameOnly -eq $params[0]) {
                powershell $_.FullName $sub_params
                return
            }
        } else {
            Iterate-Folder $_.FullName $params
        }
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