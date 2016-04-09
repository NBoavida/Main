



function PCS-Confirm-pathexists
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        Confirm-pathexists
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        Confirm-pathexists
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [System.String]
        $ImageFiles = "H:\Sports\fun_pictures\"
    )
    
    
    $ValidPath = Test-Path $ImageFiles -IsValid
    If ($ValidPath -eq $True) {Write-Host "Path is OK"}
    Else {Write-Host "Mistake in ImageFiles variable"}
}


function PCS-Get-choise
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        Get-choise
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        Get-choise
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [System.Int32]
        $Choice = 2
    )
    
    switch ($Choice)
    {
        1 {"First Choice"}
        2 {"Second Choice"}
        3 {"Third Choice"}
    }
}

function start-MyFunction 
{
invoke-expression -Command 'D:\ff\Scripts\scr\AD\ADTools.ps1'
    
}


function function helpfred
{
    [CmdletBinding()]
    param
    (
    )
    
    
    # TODO: place your function code here
    # this code gets executed when the function is called
    # and all parameters have been processed
    
    
}

 {

write-host "##############################################" -ForegroundColor DarkRed
write-host              "Help Funcions Fred " -ForegroundColor DarkCyan -BackgroundColor Yellow
write-host
write-host  "P - Ping Computer"  -ForegroundColor Yellow
Write-Host  "delusr - Remover User da AD"  -ForegroundColor Yellow
Write-Host  "bckusr - backup  User Groups"  -ForegroundColor Yellow
write-host  "delcn - Remover CN"   -ForegroundColor Yellow
write-host  "CreateDns - Remover DNS"  -ForegroundColor Yellow
write-host  "Mvusr - Mover User Edf. Centrais"   -ForegroundColor Yellow

write-host   "Uptime - Calculate and display system uptime on a local machine or remote machine."  -ForegroundColor Yellow
Write-host  "lstUpd -  list all installed hotfixes " -ForegroundColor Yellow
Write-host  "iplist -  Listing IP Addresses for a Computer"  -ForegroundColor Yellow
Write-host  "nicprop - Retrieving Network Adapter Properties" -ForegroundColor Yellow
Write-host  "renfe - Rename FE Nic"  -ForegroundColor Yellow

write-host "##############################################"   -ForegroundColor DarkRed }

