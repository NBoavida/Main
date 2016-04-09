﻿####ACP

#Inputs

$IPAddressp = '192.30.30.12' 
#$CN = Read-host 'IP' 



#Region Network

#RENAME INTERFACE
 
#Finding gatwateway
$IPByte = $IPAddressp.Split(".")
$gatwateway = ($IPByte[0]+"."+$IPByte[1]+"."+$IPByte[2]+"."+'1')

New-NetIPAddress -InterfaceAlias FE -IPAddress $ip -DefaultGateway $gatwateway -PrefixLength 24

Set-DnsClientServerAddress -InterfaceAlias FE -ServerAddresses 10.30.30.


#endregion
#######

#rename CN


#Job add domain
$trigger = New-JobTrigger -AtStartup -
 Register-ScheduledJob -Name ACP-JoinDomain -Trigger $trigger -ScriptBlock 
{
ACP-ADDTOFM
}

#updates

function Get-WinUpdates
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $UpdateSession = (New-Object -Com Microsoft.Update.Session),
        
        [Parameter(Mandatory=$false, Position=1)]
        [Object]
        $UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
    )
    
    
    Write-Host("Searching for applicable updates...") -Fore Green
    
    $SearchResult = $UpdateSearcher.Search("IsInstalled=0 and Type='Software'")
    
    Write-Host("")
    Write-Host("List of applicable items on the machine:") -Fore Green
    For ($X = 0; $X -lt $SearchResult.Updates.Count; $X++){
        $Update = $SearchResult.Updates.Item($X)
        Write-Host( ($X + 1).ToString() + "&gt; " + $Update.Title)
    }
    
    If ($SearchResult.Updates.Count -eq 0) {
        Write-Host("There are no applicable updates.")
        Exit
    }
    
    
    $UpdatesToDownload = New-Object -Com Microsoft.Update.UpdateColl
    
    For ($X = 0; $X -lt $SearchResult.Updates.Count; $X++){
        $Update = $SearchResult.Updates.Item($X)
        Write-Host( ($X + 1).ToString() + "&gt; Adding: " + $Update.Title)
        $Null = $UpdatesToDownload.Add($Update)
    }
    
    Write-Host("")
    Write-Host("Downloading Updates...")  -Fore Green
    
    $Downloader = $UpdateSession.CreateUpdateDownloader()
    $Downloader.Updates = $UpdatesToDownload
    $Null = $Downloader.Download()
    
    #Write-Host("")
    Write-Host("List of Downloaded Updates...") -Fore Green
    
    $UpdatesToInstall = New-Object -Com Microsoft.Update.UpdateColl
    
    For ($X = 0; $X -lt $SearchResult.Updates.Count; $X++){
        $Update = $SearchResult.Updates.Item($X)
        If ($Update.IsDownloaded) {
            Write-Host( ($X + 1).ToString() + "&gt; " + $Update.Title)
            $Null = $UpdatesToInstall.Add($Update)        
        } 
    }
    
    $Install = "Y"
    $Reboot  = [System.String]$Args[1]
    
    If (!$Install){
        $Install = Read-Host("Would you like to install these updates now? (Y/N)")
    }
    
    If ($Install.ToUpper() -eq "Y" -or $Install.ToUpper() -eq "YES"){
        Write-Host("")
        Write-Host("Installing Updates...") -Fore Green
        
        $Installer = $UpdateSession.CreateUpdateInstaller()
        $Installer.Updates = $UpdatesToInstall
        
        $InstallationResult = $Installer.Install()
        
        Write-Host("")
        Write-Host("List of Updates Installed with Results:") -Fore Green
        
        For ($X = 0; $X -lt $UpdatesToInstall.Count; $X++){
            Write-Host($UpdatesToInstall.Item($X).Title + ": " + $InstallationResult.GetUpdateResult($X).ResultCode)
        }
        
        Write-Host("")
        Write-Host("Installation Result: " + $InstallationResult.ResultCode)
        Write-Host("    Reboot Required: " + $InstallationResult.RebootRequired)
        
        If ($InstallationResult.RebootRequire -eq $True){
            If (!$Reboot){
                $Reboot = Read-Host("Would you like to install these updates now? (Y/N)")
            }
            
            If ($Reboot.ToUpper() -eq "Y" -or $Reboot.ToUpper() -eq "YES"){
                Write-Host("")
                Write-Host("Rebooting...") -Fore Green
                (Get-WMIObject -Class Win32_OperatingSystem).Reboot()
            }
        }
    }
}

 
