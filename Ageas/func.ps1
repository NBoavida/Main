#requires -Version 2 -Modules NetAdapter

#### 
#
# Funções
##



function PCS-del-usr
{
    $args[0] + $args[1]
}

function PCS-del-cn
{
    $args[0] + $args[1]
}

function PCS-DEL-DNs
{
    $args[0] + $args[1]
}

function PCS-CreateDns
{
    $args[0] + $args[1]
}

function PCS-p 
{
    param($computername)
    return (Test-Connection $computername  -Verbose)
}


function PCS-LoggedIn 
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [string[]]$computername
    )
 
    foreach ($pc in $computername)
    {
        $logged_in = (Get-WmiObject -Class win32_computersystem -ComputerName $pc).username
        $name = $logged_in.split('\')[1]
        '{0}: {1}' -f $pc, $name
    }
}

function PCS-Uptime 
{
    [CmdletBinding()]
    param (
        [string]$computername = 'localhost'
    )
 
    foreach ($Computer in $computername)
    {
        $pc = $computername
        $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computername
        $diff = $os.ConvertToDateTime($os.LocalDateTime) - $os.ConvertToDateTime($os.LastBootUpTime)
 
        $properties = @{
            'ComputerName' = $pc
            'UptimeDays'  = $diff.Days
            'UptimeHours' = $diff.Hours
            'UptimeMinutes' = $diff.Minutes
            'UptimeSeconds' = $diff.Seconds
        }
        $obj = New-Object -TypeName PSObject -Property $properties
 
        Write-Output -InputObject $obj
    }
}


 
function PCS-GET-SERVICE
{
    $as = $args[0] 
    Get-Service -ComputerName  $as
}
  

function PCS-lstUpd
{
    $lstUpdvar = $args[0] 
    Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $lstUpdvar  -Property  Description, HotFixId |
    Select-Object -Property  Description, HotFixId  |
    Format-Table -HideTableHeaders -AutoSize
}

 
function PCS-GET-IPLIST
{
    $iplistvar = $args[0] 
    Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName $iplistvar | Format-Table -Property IPAddress
}


function PCS-nicprop
{
    $nicsvar = $args[0] 
    Get-WmiObject -Class Win32_NetworkAdapter -ComputerName $nicsvar
}
 

function PCS-ren-fe
{
    Get-NetAdapter -Name Ethernet | Rename-NetAdapter -NewName FE -PassThru
}
 
function PCS-LADM
{
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
}

Function PCS-Test-AD 
{
    Param($username, $password, $domain)
    Add-Type -AssemblyName System.DirectoryServices.AccountManagement
    $ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain
    $pc = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext -ArgumentList ($ct, $domain)
    New-Object -TypeName PSObject -Property @{
        UserName = $username
        IsValid  = $pc.ValidateCredentials($username, $password).ToString()
    }
}

function PCS-TestPort
{
    <#
            .SYNOPSIS
            Short Description
            .DESCRIPTION
            Detailed Description
            .EXAMPLE
            Get-Something
            explains how to use the command
            can be multiple lines
            .EXAMPLE
            Get-Something
            another example
            can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, Position = 0)]
        [Object]
        $srv = (Read-Host -Prompt 'Hostname'),
        
        [Parameter(Mandatory = $false, Position = 1)]
        [Object]
        $port = (Read-Host -Prompt 'port')
    )
    
    $timeout = 3000, $verbose
    
    # Test-Port.ps1
    # Does a TCP connection on specified port (135 by default)
    
    $ErrorActionPreference = 'SilentlyContinue'
    
    # Create TCP Client
    $tcpclient = New-Object -TypeName system.Net.Sockets.TcpClient
    
    # Tell TCP Client to connect to machine on Port
    $iar = $tcpclient.BeginConnect($srv,$port,$null,$null)
    
    # Set the wait time
    $wait = $iar.AsyncWaitHandle.WaitOne($timeout,$false)
    
    # Check to see if the connection is done
    if(!$wait)
    {
        # Close the connection and report timeout
        $tcpclient.Close()
        if($verbose)
        {
            Write-Host -Object 'Connection Timeout'
        }
        Return $false
    }
    else
    {
        # Close the connection and report the error if there is one
        $error.Clear()
        $null = $tcpclient.EndConnect($iar)
        if(!$?)
        {
            if($verbose)
            {
                Write-Host -Object $error[0]
            }
            $failed = $True
        }
        $tcpclient.Close()
    }
    
    # Return $true if connection Establish else $False
    if($failed)
    {
        return $false
    }
    else
    {
        return $True
    }
}

function PCS-Confirm-Fileexist
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        Confirm-Fileexist
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        Confirm-Fileexist
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [System.String]
        $WantFile = "C:\Windows\explorer.exe"
    )
    
    
    $FileExists = Test-Path $WantFile 
    If ($FileExists -eq $True) {Write-Host "Yippee"}
    Else {Write-Host "No file at this location"}
}


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


