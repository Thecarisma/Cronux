<#
.SYNOPSIS
    Execute a command in a pod using it full name or select from 
    matching pods.
.DESCRIPTION
    Execute a command in a pod using it full name or select from 
    matching pods.
    Kubectl is required for this command to work, 
    it can be downloaded from 
    https://kubernetes.io/docs/tasks/tools/install-kubectl/
    
    The commands after the pod name are executed.
    
.INPUTS 
    [System.String]
.OUTPUTS 
    Commands Output
.NOTES
    Version    : 1.0
    File Name  : podexec.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : March-31-2019
.LINK
    https://thecarisma.github.io/Cronux
    https://kubernetes.io/docs/reference/kubectl
.EXAMPLE
    podexec mypod ls /
    Find all pod that match the name 'mypod' then use 
    the index to select the pod. Then execute the command 
    'ls /' in pod.
.EXAMPLE
    podexec mypod-service-5d94df45ff-pnnn
    Execute the command 'ls /' in the pod 
    mypod-service-5d94df45ff-pnnn if found in the 
    current context.
#>

[CmdletBinding()]
Param(
    # the full pod name or matching part of pod name
    [Parameter(Mandatory=$true, Position=0)]
    [string]$PodName,
    [Parameter(Mandatory=$true, ValueFromRemainingArguments = $true)]
    [string[]]$Commands
)

Function main {
    $Pods = @()
    $(kubectl get pods | findstr $PodName) | ForEach-Object {
        $Result = Parse-Pod-Detail $($_ -replace '\s+', ' ')
        $Pods += $Result
        if ($Single) {
            break
        }
    }
    
    $Pod_Name = ""
    if ($Pods.Length -eq 0) {
        "No pod found matching the name: $PodName" | Write-Host -Fore red
        return
    }
    if ($Pods.Length -gt 1) {
        $Index = 0
        ForEach ($Apod in $Pods) {
            "$($Index): $($Apod.Name)"
            $Index++
        }
        $Loc = Read-Host 'Which pod do you want to log? '
        $Pod_Name = $Pods[$Loc].Name
        if (-not $Pod_Name) {
            "Invalid index specified '$Loc'" | Write-Host -Fore red
            return
        }
    } else {
        $Pod_Name = $Pods[0].Name
    }
    Pod-Shell $Pod_Name
}

Function Pod-Shell {
    Param(
        [string]$Pod_Name
    )
    
    kubectl exec $Pod_Name -- $Commands   
}

Class MinPod {
    [string]$Name
}

Function Parse-Pod-Detail {
    Param(
        [string]$Pod_Line
    )
    
    $APod = New-Object MinPod
    $Splited = $Pod_Line.Split(" ")
    $Index = 0
    
    ForEach ($Token in $Splited) {
        if ($Index -eq 0) {
            $APod.Name = $Token
            
        }
        $Index++
    }
    
    return $APod
}

main

