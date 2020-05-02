<#
.SYNOPSIS
    A robust sub shell for powershell
.DESCRIPTION
    Support inline execution, sub shell and shebang 
    line execution. Hebang execution also :). The hebang 
    line is similar to shebang just that instead of '#' 
    it expect '//'. The value of {0} is the full path 
    to the file and can be used in the shebang and hebang 
    line. 
    
    The hebang can be used to compile a file 
    before executing it. e.g the following c source 
    file is compiled then executed, test.c
    
    ```
    //!gcc {0} -o test; ./test
    #include <stdio>
    int main() {
        printf("hello world");
    }
    ```
    
    Then execute this in the CLI. The file test.c will 
    be compile and executed. The hebang line will expands 
    to `gcc C:/full/path/test.c -o test; ./test`    
    
    
    ```
    $ ./test.c
    ```
    
    will prints 'hello world' in the console. 
    
    If no command is specified to the script it will enter 
    a subshell where command can be executed line by line. 
    The subshell is simply a powershell REPL which evaluates 
    shebang and hebang line in file if specified.
.INPUTS 
    [System.String[]]
.OUTPUTS 
    System.String
.NOTES
    Version    : 1.0
    File Name  : $.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Apr-09-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    $ 
    Enter the powershell sub shell which evaluates 
    shebang and hebang line.
.EXAMPLE
    $ echo 'this is it'
    Prints 'this is it' in the console
#>

Param(
    # the commands to execute or the file to execute
    [Parameter(Mandatory=$false, ValueFromRemainingArguments = $true)]
    [string[]]$Commands
)

Function Main {
    If ($Commands) {
        Evalute-Line $Commands
    } Else {
        Enter-Shell
    }
}

Function Enter-Shell {
    while ($true) {
       $Commands = Read-Host "$"
       Evalute-Line $Commands
    }
}

Function Evalute-Line {
    Param(
        [string]$LineArgs
    )
    
    $FirstCommand = ""
        $OtherCommands = ""
        ForEach ($Command in $Commands) {
            If (-not $FirstCommand) {
                $FirstCommand = $Command
                If ($FirstCommand -eq "exit()" -or $FirstCommand -eq "exit" -or $FirstCommand -eq "close") {
                    exit
                }
            } else {
                if ($Command.Contains(" ")) {
                    $OtherCommands += "'$Command' "
                } else {
                    $OtherCommands += "$Command "
                }
            }
        }
        $Old_CD = [Environment]::CurrentDirectory
        [Environment]::CurrentDirectory = Get-Location
        $FirstCommand = Resolve-Shebang $FirstCommand
        [Environment]::CurrentDirectory = $Old_CD
        iex "$FirstCommand $OtherCommands"
}

Function Resolve-Shebang {
    Param(
        [string]$FirstCommand_
    )
    
    If ([System.IO.File]::Exists($FirstCommand_)) {
        foreach($Line in Get-Content $FirstCommand_) {
            If($Line.StartsWith("#!")){
                $Shebang = $Line.SubString(2, $Line.Length - 2)
                $Bangs = $Shebang.Split(" ")
                $Shebang = ""
                ForEach ($Bang in $Bangs) {
                    If ($Bang.StartsWith('/') -and ($Bang.EndsWith('/env') -or $Bang.EndsWith('/bin'))) {
                    
                    } Else {
                        $Shebang += "$Bang "
                    }
                }
                return $Shebang + ' ' + [System.IO.Path]::GetFullPath($FirstCommand_)
            } ElseIf ($Line.StartsWith("//!")){
                $Hebang = $Line.SubString(3, $Line.Length - 3)
                $Bangs = $Hebang.Split(" ")
                $Hebang = ""
                ForEach ($Bang in $Bangs) {
                    If ($Bang.StartsWith('/') -and ($Bang.EndsWith('/env') -or $Bang.EndsWith('/bin'))) {
                    
                    } Else {
                        $Hebang += "$Bang "
                    }
                }
                $Hebang = $Hebang -f [System.IO.Path]::GetFullPath($FirstCommand_)
                return $Hebang
            }
            return $FirstCommand_
        }
    }
    return $FirstCommand_
}

Main