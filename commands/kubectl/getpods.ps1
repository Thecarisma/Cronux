<#
.SYNOPSIS
   List the ip addresses of a url
.DESCRIPTION
    Find pod by it name or matching part of a pod name using 
    kubectl. Kubectl is required for this command to work, it 
    can be downloaded from https://kubernetes.io/docs/tasks/tools/install-kubectl/
    
    If more than one pod is found that matches the specified 
    name, they will be printed. This command returns an iterabele 
    array of the Pod Object.
    
    Pod Object
    ----------
    {
        Name,
        Ready,
        Status,
        Restarts,
        Age,
        Namespace,
        Node,
        StartTime,
        Labels [
            
        ]
        Anotations,
        IP,
        ControlledBy,
        Containers [
            [index] {
                Name,
                ContainerId,
                Port,
                HostPort,
                State,
                Started,
                Image,
                ImageId,
                FileSystem,
                Limit {
                    Cpu,
                    Memory
                },
                Requests {
                    Cpu,
                    Memory
                },
                Liveliness,
                Readiness,
                Environments {
                    'key': 'value'
                    ....
                },
                Mounts [
                    "/data ..",
                    "/var/..."
                ],
            }
        ]
        Conditions {
            Type,
            Initialized,
            Ready,
            PodScheduled
        },
        Volumes [
            [index] {
                Name,
                Type,
                Fields {
                    'key': 'value'
                }
            }
        ],
        QosClass,
        Node-Selectors,
        Tolerations,
        Events [
        
        ]        
    }
    
.INPUTS 
    [System.String]
.OUTPUTS 
    [Pod][]
.NOTES
    Version    : 1.0
    File Name  : getpods.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : March-25-2019
.LINK
    https://thecarisma.github.io/Cronux
    https://kubernetes.io/docs/reference/kubectl
.EXAMPLE
    getpods mypod-service-5d94df45ff-pnnn
    This will print out the pod detail of that specific pod 
    if found else nothin is printed out
.EXAMPLE
    getpods mypod
    If more than one pod has the name 'mypod' all the pod 
    with the name 'mypod' will be printed in the terminal
#>

[CmdletBinding()]
Param(
    # the full pod name or matching part of name
    [string]$PodName,
    # this only fetch the basic info of a pod, name, ready, status. restarts, age
    [switch]$BasicInfo,
    # get only the first pod that matches the name
    [switch]$Single
)
$

