<#
.SYNOPSIS
    Find all pods in the current context or pods 
    by it name or matching part of a pod name
.DESCRIPTION
    Find all pods in the current context or pods 
    by it name or matching part of a pod name kubectl. 
    Kubectl is required for this command to work, it 
    can be downloaded from https://kubernetes.io/docs/tasks/tools/install-kubectl/
    
    If more than one pod is found that matches the 
    specified name, they will be printed. This command 
    returns an iterabele array of the Pod Object.
    
    Pod Object
    ----------
    {
        Name
        Ready
        Status
        Restarts
        Age
        Namespace
        Priority
        PriorityClassName
        Node
        StartTime
        IP
        Image      
    }
    
.INPUTS 
    [System.String]
.OUTPUTS 
    [Pod[]]
.NOTES
    Version    : 1.0
    File Name  : getpods.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : March-25-2019
.LINK
    https://thecarisma.github.io/Cronux
    https://kubernetes.io/docs/reference/kubectl
.EXAMPLE
    getpods
    This will print out all the pod detail 
    in the current context
.EXAMPLE
    getpods mypod-service-5d94df45ff-pnnn
    This will print out the pod detail of that 
    specific pod if found else nothin is printed 
    out
.EXAMPLE
    getpods mypod
    If more than one pod has the name 'mypod' 
    all the pod with the name 'mypod' will be 
    printed in the terminal
#>

[CmdletBinding()]
Param(
    # the full pod name or matching part of name
    [Parameter(Position=0)]
    [string]$PodName,
    # this returns as array of the Pod class that can be iterated
    [switch]$Detail,
    # get only the first pod that matches the name
    [switch]$Single
)

Function main {
    if (-not $Detail) {
        if ($PodName) {
            kubectl get pods | findstr $PodName
        } else {
            kubectl get pods
        }
        return
    }
    $Pods = New-Object System.Collections.ArrayList
    if ($PodName) {
        $(kubectl get pods | findstr $PodName) | ForEach-Object {
            $Result = Parse-Pod-Detail $($_ -replace '\s+', ' ')
            $Pods.Add($Result) > $null
            if ($Single) {
                break
            }
        }
    } else {
        $DoneWithHeader = $False
        $(kubectl get pods) | ForEach-Object {
            if ($DoneWithHeader) {
                $Result = Parse-Pod-Detail $($_ -replace '\s+', ' ')
                $Pods.Add($Result) > $null
                if ($Single) {
                    break
                }
            } else {
                $DoneWithHeader = $True
            }
        }
    }
    return $Pods
}

Class Pod {
    [string]$Name
    [string]$Ready
    [string]$Status
    [string]$Restarts
    [string]$Age
    [string]$Namespace
    [string]$Priority
    [string]$PriorityClassName
    [string]$Node
    [string]$StartTime
    [string]$IP
    [string]$Image
}

Function Parse-Pod-Detail {
    Param(
        [string]$Pod_Line
    )
    
    $APod = New-Object Pod
    $Splited = $Pod_Line.Split(" ")
    $Index = 0
    
    ForEach ($Token in $Splited) {
        if ($Index -eq 0) {
            $APod.Name = $Token
            
        } elseif($Index -eq 1) {
            $APod.Ready = $Token
            
        }  elseif($Index -eq 2) {
            $APod.Status = $Token
            
        }  elseif($Index -eq 3) {
            $APod.Restarts = $Token
            
        }  elseif($Index -eq 4) {
            $APod.Age = $Token
            
        } 
        $Index++
    }
    $(kubectl describe pod $APod.Name) | ForEach-Object {
        $Line = $_        
        $Value = ""
        if ($Line.Contains(":")) {
            $Offset = $Line.IndexOf(":") + 1
            $Value = $Line.SubString($Offset, $Line.Length - $Offset).Trim()
        }
        if ($Line.StartsWith("Namespace")) {
            $APod.Namespace = $Value
            
        } elseif ($Line.StartsWith("PriorityClassName")) {
            $APod.PriorityClassName = $Value
            
        } elseif ($Line.StartsWith("Priority")) {
            $APod.Priority = $Value
            
        } elseif ($Line.StartsWith("Node")) {
            $APod.Node = $Value
            
        } elseif ($Line.StartsWith("Start Time")) {
            $APod.StartTime = $Value
            
        } elseif ($Line.StartsWith("IP")) {
            $APod.IP = $Value
            
        }elseif ($Line.Trim().StartsWith("Image")) {
            if (-not $APod.Image) {
                $APod.Image = $Value
            }
            
        }
    }
    
    return $APod
}

main

