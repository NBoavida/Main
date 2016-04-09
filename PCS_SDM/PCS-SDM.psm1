

#region Module vars.

$pcssdmScr = 'D:\ff\Scr'
$pcssdmOUT = 'D:\ff\Outputs'

#endregion

#region Version
$PCSver = '2.0'
$PCSDeploydate = '26-01-2016'
#endregion

#region ForceUpdate

function Update-PCS {

Import-Module PCS-SDM  -Force
	
}

#endregion


function GET-USERSCRIADOS
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        PCS-USERSCRIADOS
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        PCS-USERSCRIADOS
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $UserIni = (Read-Host 'Qual o UserID... inicial?'),
        
        [Parameter(Mandatory=$false, Position=1)]
        [Object]
        $UserFim = (Read-Host 'Qual o UserID... final?')
    )
     ADD-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
    $filtro= '-filter {name -ge "' + $UserIni + '" -and name -le "' + $UserFim + '"}'
    #"$filtro"
    $cmd = "get-mailbox $filtro"
    #"$cmd"
    invoke-expression $cmd | 
    select @{name="UserID"; expression={$_.name}}, @{name="Nome"; expression={$_.displayname}}, @{name="email"; expression={$_.windowsemailaddress}}, @{name="Password"; expression={"654321a*"}} | 
    fl
}

function GET-REBOOTS
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        PCS-REBOOTS
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        PCS-REBOOTS
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $maquina = (read-host Hostname)
    )
    
    Get-EventLog -LogName System -ComputerName $maquina |
    where {$_.EventId -eq 1074} |
    ForEach-Object {
        
        $rv = New-Object PSObject | Select-Object Date, User, Action, process, Reason, ReasonCode, Comment, Message
        if ($_.ReplacementStrings[4]) {
            $rv.Date = $_.TimeGenerated
            $rv.User = $_.ReplacementStrings[6]
            $rv.Process = $_.ReplacementStrings[0]
            $rv.Action = $_.ReplacementStrings[4]
            $rv.Reason = $_.ReplacementStrings[2]
            $rv.ReasonCode = $_.ReplacementStrings[3]
            $rv.Comment = $_.ReplacementStrings[5]
            $rv.Message = $_.Message
            $rv
        }
    } | Select-Object Date, Action, Reason, User 
}


function Add-Net-grp
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        PCS-ADDNET
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        PCS-ADDNET
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $user = (Read-Host Username)
    )
    
    Add-ADGroupMember -Identity G-AcessoInternet -Members $user -Confirm:$false
    
    Remove-ADGroupMember  G-AcessoIntranet -Members $user  -ErrorAction SilentlyContinue -Confirm:$false
    
    
    Get-ADPrincipalGroupMembership $user | select name
}

function Get-PCS-help {
Write-Host $xoutput

}

function Find-GRP
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        PCS-GRP
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        PCS-GRP
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $grp = (Read-host "Group")
    )
    
    
    
    Get-ADGroup -Filter {name -like $grp} -Properties * | select Name, description
}


function Export-memberof
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        PCS-GRP
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        PCS-GRP
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $p1 = (Read-host "Group")
    )
   

if ($PSBoundParameters.keys.count -eq 1)
{
	$x_grupo = $PSBoundParameters["p1"]
}else
{
	$x_grupo = 	Read-Host 'GroupName?'
}

Try {
$x_Members = Get-ADGroupMember $x_grupo
}
Catch {
	Write-Host "`nGroupID: <$x_grupo>"
	Write-Host "`nÉ necessário indicar um GroupID válido para exportar os membros."
	exit
}

$x_File_Out_Csv = "d:\scripts\ad\Get-ADMembers\Get-ADMembers_" + $x_grupo + "_"+ (get-random) + ".csv"

Import-Module ActiveDirectory 
$x_Members | 
	Get-ADObject -Properties sAMAccountName, displayName | 
		Select-Object @{name="Grupo"; expression={$x_grupo}}, sAMAccountName, DisplayName | sort sAMAccountName |
			Export-Csv $x_File_Out_Csv -Encoding UTF8 -Append -Delimiter ";" -notypeinformation

echo "Backup criado !"
echo $x_File_Out_Csv
Echo "======================================================="
}



function Update-DNSRecord
{

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $novoip = (Read-host 'Novo IP'),
        
        [Parameter(Mandatory=$false, Position=1)]
        [Object]
        $NodeTouPDATE = (Read-host 'DNS Record (A Type)'),
        
        [Parameter(Mandatory=$false, Position=2)]
        [System.String]
        $DNSServer = "spf6001dcs13.fidelidademundial.com"
    )
    
    $ZoneName = "fidelidademundial.com"
    $NodeDNS = $null
    $NodeDNS = Get-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DNSServer -Node $NodeTouPDATE -RRType A -ErrorAction SilentlyContinue
    if($NodeDNS -eq $null){
        Write-Host "No DNS record found" -ForegroundColor red
    } else {
        Remove-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DNSServer -InputObject $NodeDNS -Force
        write-host "Registo de DNS $NodeToDelete Removido" -ForegroundColor green
    }
    
    
    Add-DnsServerResourceRecordA -Name $NodeTouPDATE -ZoneName $ZoneName  -ComputerName $DNSServer -AllowUpdateAny -IPv4Address $novoip
}

function Dep-Clean-SCOM-CACHE
{
    
    SC.exe 'stop' HealthService
    
    Start-Sleep 5
    
    Remove-Item -Path "C:\Program Files\Microsoft Monitoring Agent\Agent\Health Service State" -Force -Confirm:$false
    
    SC.exe 'start' HealthService
}


function Dep-Rename-Nic
{
    Get-NetAdapter -Name Ethernet | Rename-NetAdapter -NewName FE -PassThru
}

function Add-Rassis
{
 
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $user = (Read-Host Username)
    )
    
    Add-ADGroupMember -Identity D-FacetsIB-S -Members $user -Confirm:$false
    
    
    
    Get-ADPrincipalGroupMembership $user | select name
}

function Dep-Remove-CN
{

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $cn = (read-host "CN a Remover")

 )
    
    Remove-ADComputer -Identity $cn | Write-Output
}

function Get-Member_of
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        Get-Member_of
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        Get-Member_of
        another example
        can have as many examples as you like
    #>
    param($p1, $p2)
    cls
    Add-Type -AssemblyName System.Windows.Forms
    
    Function PreencherHashTables ($x_Tipo) {  
        # Função para preencher HashTables com grupos dos users a alterar e a de referência
        
        switch ($x_Tipo) 
        { 
            "AD" {
                $global:x_UserAlterarMemberOf_Ini=("")
                $global:x_UserAlterarMemberOf = @{}
                $global:x_UserRefMemberOf_Ini=("")
                $global:x_UserRefMemberOf = @{}
                
                $global:x_UserAlterarMemberOf_Ini = Get-ADPrincipalGroupMembership $global:x_UserAlterar | sort name
                if ($global:x_UserAlterarMemberOf_Ini -eq $null)
                {
                    Write-Host "`nUserID a alterar <$global:x_UserAlterar> não existe."
                    exit
                }
                $global:x_UserRefMemberOf_Ini = Get-ADPrincipalGroupMembership $global:x_UserRef | sort name
                if ($global:x_UserRefMemberOf_Ini -eq $null)
                {
                    Write-Host "`nUserID de referência <$global:x_UserRef> não existe."
                    exit
                }
                $global:x_UserAlterarMemberOf_Ini | %{$global:x_UserAlterarMemberOf.add($_.name,(0,$_.distinguishedName)) }
                $global:x_UserRefMemberOf_Ini | %{$global:x_UserRefMemberOf.add($_.name,(0,$_.distinguishedName)) }
            } 
            
            "Set" {
                $global:x_UserAlterarMemberOf_Ini=("")
                $global:x_UserAlterarMemberOf = @{}
                $global:x_UserAlterarMemberOf_Ini = Get-ADPrincipalGroupMembership $global:x_UserAlterar | sort name
                if ($global:x_UserAlterarMemberOf_Ini -eq $null)
                {
                    Write-Host "`nUserID a alterar <$global:x_UserAlterar> não existe."
                    exit
                }
                $global:x_UserAlterarMemberOf_Ini | %{$global:x_UserAlterarMemberOf.add($_.name,(0,$_.distinguishedName)) }
            }
       }
    }
    
    
    Function MakeNewForm {
        $Form.Close()
        $Form.Dispose()
        MakeForm
    }
    
    Function ExecuteCmdSetReload {
        
        PreencherHashTables("AD")
        [System.Windows.Forms.MessageBox]::Show("Reload completo!", 'Info', 'Ok', 'Info')
        MakeNewForm
    }
    
    
    #
    #   Estado dos grupos dentro da HASH Table
    #
    #   Estados superiores a 5, são para eliminar
    #
    #   Grupo com valor :
    #        0 - Grupo lido directamente da AD e será mantido
    #        1 - Grupo transferido do user de referência e será criado
    #        2 - Grupo transferido do user de referência e mas já existia
    #        9 - Grupo lido directamente da AD e será eliminado
    #        8 - Grupo transferido do user de referência. Depois foi marcado para eliminado. Como não existe na AD não tem de ser eliminado.
    #
    
    Function ExecuteCmdSetRetirar {
        if (!$ListBoxUserAlterar.SelectedItems) {
            [System.Windows.Forms.MessageBox]::Show("Não seleccionou nenhum Grupo a retirar!", 'Critical', 'Ok', 'Error')
            return
        }
        $ListBoxUserAlterar.SelectedItems |    %{
            $x_Grupo = $_
            switch ($global:x_UserAlterarMemberOf[($x_Grupo)][0])
            {
                0
                {
                    $global:x_UserAlterarMemberOf[($x_Grupo)][0] = 9
                }
                2
                {
                    $global:x_UserAlterarMemberOf[($x_Grupo)][0] = 9
                }
                1
                {
                    $global:x_UserAlterarMemberOf.Remove(($x_Grupo))
                }
            }
        }
        $global:x_Status = "Alterações pendentes ......"
        MakeNewForm
        
    }
    
    Function ExecuteCmdSetAdicionar {
        if (!$ListBoxUserRef.SelectedItems) {
            [System.Windows.Forms.MessageBox]::Show("Não seleccionou nenhum Grupo a adicionar!", 'Critical', 'Ok', 'Error')
            return
        }
        $ListBoxUserRef.SelectedItems | %{
            if ($global:x_UserAlterarMemberOf.Contains($_))
            {
                $global:x_UserAlterarMemberOf[$_][0] = 2
                $global:x_UserAlterarMemberOf[$_][1] = $global:x_UserRefMemberOf[$_][1]
            } else
            {
                $global:x_UserAlterarMemberOf.add($_,(1,$global:x_UserRefMemberOf[$_][1]))
            }
            $global:x_UserRefMemberOf[$_][0] = 9
        }
        $global:x_Status = "Alterações pendentes ......"
        MakeNewForm
    }
    
    Function ExecuteCmdSet {
        
        Invoke-Expression "D:\Scripts\AD\User_MemberOf.ps1 $global:x_UserAlterar"
        $global:x_UserAlterarMemberOf.keys | %{
            $x_CN = $global:x_UserAlterarMemberOf[($_)][1]
            $x_Estado = $global:x_UserAlterarMemberOf[($_)][0]
            if ($x_Estado -eq 1)
            {
                Add-ADPrincipalGroupMembership $global:x_UserAlterar $x_CN
            }
            if ($x_Estado -eq 9)
            {
                Remove-ADPrincipalGroupMembership $global:x_UserAlterar $x_CN -Confirm:$false
            }
        }
        
        PreencherHashTables("Set")
        $global:x_Status = ""
        [System.Windows.Forms.MessageBox]::Show("Alterações efetuadas!", 'Info', 'Ok', 'Info')
        MakeNewForm 
    }
    
    Function MakeForm {
        
        $script:Form = New-Object system.Windows.Forms.Form
        $Form.Text = "Mudança Posto Trabalho - MemberOf"
        $Form.Size = New-Object System.Drawing.Size(645,580)
        $Form.StartPosition = "CenterScreen"
        
        $LabelUserAlterar = New-Object System.Windows.Forms.Label
        $LabelUserAlterar.Location = New-Object System.Drawing.Size(10,5) 
        $LabelUserAlterar.Size = New-Object System.Drawing.Size(260,15) 
        $LabelUserAlterar.Text = "UserID a Alterar: <" + $global:x_UserAlterar + ">"
        
        $LabelUserAlterarMemberOf = New-Object System.Windows.Forms.Label
        $LabelUserAlterarMemberOf.Location = New-Object System.Drawing.Size(10,20) 
        $LabelUserAlterarMemberOf.Size = New-Object System.Drawing.Size(260,15) 
        $LabelUserAlterarMemberOf.Text = "MemberOf"
        
        $ListBoxUserAlterar = New-Object System.Windows.Forms.ListBox
        $ListBoxUserAlterar.Location = New-Object System.Drawing.Size(10,35)
        $ListBoxUserAlterar.Size = New-Object System.Drawing.Size(260,120)
        $ListBoxUserAlterar.Height = 450
        $ListBoxUserAlterar.SelectionMode = "MultiExtended"
        $ListBoxUserAlterar.Sorted=$true
        $global:x_UserAlterarMemberOf.Keys | %{
            $x_ItemList = $_
            if ($global:x_UserAlterarMemberOf[($_)][0] -le 5) 
            {
                [void] $ListBoxUserAlterar.Items.Add($x_ItemList)
            }
        }
        
        $LabelUserRef = New-Object System.Windows.Forms.Label
        $LabelUserRef.Location = New-Object System.Drawing.Size(360,5) 
        $LabelUserRef.Size = New-Object System.Drawing.Size(260,15) 
        $LabelUserRef.Text = "UserID de Referência: <" + $global:x_UserRef + ">"
        
        $LabelUserRefMemberOf = New-Object System.Windows.Forms.Label
        $LabelUserRefMemberOf.Location = New-Object System.Drawing.Size(360,20) 
        $LabelUserRefMemberOf.Size = New-Object System.Drawing.Size(260,15) 
        $LabelUserRefMemberOf.Text = "MemberOf"
        
        $ListBoxUserRef = New-Object System.Windows.Forms.ListBox
        $ListBoxUserRef.Location = New-Object System.Drawing.Size(360,35)
        $ListBoxUserRef.Size = New-Object System.Drawing.Size(260,120)
        $ListBoxUserRef.Height = 450
        $ListBoxUserRef.SelectionMode = "MultiExtended"
        $ListBoxUserRef.Sorted=$true
        $global:x_UserRefMemberOf.Keys | %{
            $x_ItemList = $_
            if ($global:x_UserRefMemberOf[($_)][0] -le 5) 
            {
                [void] $ListBoxUserRef.Items.Add($x_ItemList)
            }
        }
        
        $ButtonSetRetirar = New-Object System.Windows.Forms.Button
        $ButtonSetRetirar.Location = New-Object System.Drawing.Size(280,60)
        $ButtonSetRetirar.Size = New-Object System.Drawing.Size(60,20)
        $ButtonSetRetirar.Text = "( X )"
        $ButtonSetRetirar.Add_Click({ExecuteCmdSetRetirar})
        
        $ButtonSetAdicionar = New-Object System.Windows.Forms.Button
        $ButtonSetAdicionar.Location = New-Object System.Drawing.Size(280,90)
        $ButtonSetAdicionar.Size = New-Object System.Drawing.Size(60,20)
        $ButtonSetAdicionar.Text = "<<<"
        $ButtonSetAdicionar.Add_Click({ExecuteCmdSetAdicionar})
        
        $ButtonSet = New-Object System.Windows.Forms.Button
        $ButtonSet.Location = New-Object System.Drawing.Size(210,490)
        $ButtonSet.Size = New-Object System.Drawing.Size(60,20)
        $ButtonSet.Text = "Set"
        $ButtonSet.Add_Click({ExecuteCmdSet})
        
        $ButtonReload = New-Object System.Windows.Forms.Button
        $ButtonReload.Location = New-Object System.Drawing.Size(360,490)
        $ButtonReload.Size = New-Object System.Drawing.Size(60,20)
        $ButtonReload.Text = "Reload"
        $ButtonReload.Add_Click({ExecuteCmdSetReload})
        
        $LabelStatus = New-Object System.Windows.Forms.Label
        $LabelStatus.Location = New-Object System.Drawing.Size(10,515) 
        $LabelStatus.Size = New-Object System.Drawing.Size(610,15) 
        $LabelStatus.Text = $global:x_Status
        $LabelStatus.BorderStyle = 1
        
        $Form.Controls.Add($LabelUserAlterar)
        $Form.Controls.Add($LabelUserAlterarMemberOf)
        $Form.Controls.Add($ListBoxUserAlterar)
        
        $Form.Controls.Add($LabelUserRef)
        $Form.Controls.Add($LabelUserRefMemberOf)
        $Form.Controls.Add($ListBoxUserRef)
        
        $Form.Controls.Add($ButtonSetRetirar)
        $Form.Controls.Add($ButtonSetAdicionar)
        $Form.Controls.Add($ButtonSet)
        $Form.Controls.Add($ButtonReload)
        $Form.Controls.Add($LabelStatus)
        $Form.ShowDialog()
    }
    
    #
    #    Inicio do Corpo Principal do Programa
    #
    
    # ## Inicio  Teste parametros entrada
    
    if ($PSBoundParameters.keys.count -eq 2)
    {
        $global:x_UserAlterar = $PSBoundParameters["p1"]
        $global:x_UserRef = $PSBoundParameters["p2"]
    }else
    {
        $global:x_UserAlterar =   Read-Host 'UserId a alterar?'
        $global:x_UserRef =             Read-Host 'UserID de referência?'
    }
    
    if ($global:x_UserAlterar -eq $null -or $global:x_UserAlterar -le "      " )
    {
        Write-Host "`nÉ necessário indicar um UserID a alterar."
        exit
    }
    
    if ($global:x_UserRef -eq $null -or $global:x_UserRef -le "      " )
    {
        Write-Host "`nÉ necessário indicar um UserID de referência."
        exit
    }
    # ## Fim  Teste parametros entrada
    
    $global:x_Status=""
    PreencherHashTables("AD")
    
    MakeForm
}

function Dep-Rename-CN
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        PCS-CN
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        PCS-CN
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $novocn = (Read-Host 'Novo CN')
    )
    
    Rename-Computer -ComputerName $env:COMPUTERNAME  -NewName $novocn
}

function Dep-Install-WinUpdates
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

function DEL-ADuser
{


    <#
        .SYNOPSIS
        Remove a User from AD
        .DESCRIPTION
        Delete user
        .EXAMPLE
        DEL-ADuser user
    
        .EXAMPLE
         DEL-ADuser user  $chg CHG-1211 -xnuc user 
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $chg = (Read-Host Change_ID),
        
        [Parameter(Mandatory=$false, Position=1)]
        [Object]
        $xnuc = (Read-host Username Para Apagar)
        
    )
	
	$User = Get-ADUser -LDAPFilter "(sAMAccountName=$xnuc)"
If ($User -eq $Null) {"User does not exist in AD"}
Else { 
    
    #Var
    
     $discricao = (get-aduser $xnuc -Properties Description | select  Description)
    
    $dia = get-date -Format dd.M.yyyy
    $NewHomeDir = "_$xnuc"
    $ADUser = Get-AdUser $xnuc -Properties HomeDirectory
    $ADUser.HomeDirectory | Write-Output
    $1 = $discricao.Description | Write-Output
    
    #backup user
    Write-Host Backup User.. 
    get-aduser $xnuc -Properties Description | select  Description >> D:\Scripts\AD\Remover_User\$Xnuc.log
    Get-ADPrincipalGroupMembership $xnuc | select name >> D:\Scripts\AD\Remover_User\$Xnuc.log
    
    
    #Update Display name 
    Write-Host Update Description
    Set-ADUser -Identity $xnuc -Description "$chg; Delete User; $dia; $1 "
    
    #Rename Homedir 
    Write-Host Rename $ADUser.HomeDirectory to $NewHomeDir
    Rename-Item -Path $ADUser.HomeDirectory -NewName $NewHomeDir
    
    #remove user
    Write-Host  A remover $xnuc
    Remove-ADUser -Identity $xnuc
	}
}
 
function Move-Utilizador
{
    <#
        .SYNOPSIS
        Mover User entre Direções 
        .DESCRIPTION
        Mover User entre Direções 
        - Backup User Grupos
        - Update Dysplayname
        - Update descrição
        - Member OF v5
        - Get new homeDir
        - copy Home folder content
        - Move user de OU
        .EXAMPLE
        Move-Utilizador - Change CHG-123 -UserName User1 -UserNametemplate UserNametemplate
        .EXAMPLE
        Move-Utilizador CHG-123  User1  UserNametemplate
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $Change = (read-host  "Change ID"),
        
        [Parameter(Mandatory=$false, Position=1)]
        [Object]
        $UserName = (read-host "Username"),
        
        [Parameter(Mandatory=$false, Position=2)]
        [Object]
        $UserNametemplate = (read-host "username template")
    )
  
  Start-Transcript D:\ff\Outputs\$Change.txt

$User = Get-ADUser -LDAPFilter "(sAMAccountName=$UserName)"
If ($User -eq $Null) {"User does not exist in AD"}
Else { 
Write-host "User found in AD, Begin Process!! "


$hora= get-date

$xoutput = @"
"********************************
Dia: $hora
********************************
Chnage ID: Change
User a Mudar $UserName
User template $UserNametemplate
********************************" 
"@

Write-Host "Backup User.. "
Get-ADPrincipalGroupMembership $UserName | select name >> D:\Scripts\AD\bckgrps\$UserName.log
Write-Host "Actualizar Descrição" -ForegroundColor Green
$discricao = get-aduser $UserNametemplate -Properties Description | select  Description 
$nova_discricao = $discricao.Description | Write-Output
$olddisc = get-aduser $UserName -Properties Description | select  Description
$olddisc1 = $olddisc.Description | Write-Output
Set-ADUser -Identity $UserName -Description $nova_discricao 
Write-Host " Finnish Set user Descrição de $olddisc1  para $nova_discricao  " -ForegroundColor Green

#get user temmplate Displayname Departamento 
$givenNametpl =  get-aduser $UserNametemplate -Properties GivenName | select  GivenName
$givenName1tpl =  $givenNametpl.GivenName | Write-Output
$Surnametpl =  get-aduser $UserNametemplate -Properties Surname | select  Surname
$Surname1tpl =  $Surnametpl.Surname | Write-Output
$DisplayNametpl =  get-aduser $UserNametemplate -Properties DisplayName | select  DisplayName
$DisplayName1tpl =  $DisplayNametpl.DisplayName | Write-Output

#get user  Displayname  
$givenName =  get-aduser $UserName -Properties GivenName | select  GivenName
$givenName1 =  $givenName.GivenName | Write-Output
$Surname =  get-aduser $UserName -Properties Surname | select  Surname
$Surname1 =  $Surname.Surname | Write-Output

#novo Departamento
$dep= $DisplayName1tpl –replace $givenName1tpl –replace $Surname1tpl


#novodisplayname 
$newDisplayname = "$givenName1 $Surname1$dep"


Write-Host "A Actualizar DisplayName de $givenName1 para $newDisplayname" -ForegroundColor Green
Set-ADUser -Identity $UserName -DisplayName $newDisplayname




#region Grupos
param($p1, $p2)

Add-Type -AssemblyName System.Windows.Forms

Function PreencherHashTables ($x_Tipo) {  
# Função para preencher HashTables com grupos dos users a alterar e a de referência

	switch ($x_Tipo) 
    { 
        "AD" {
				$global:x_UserAlterarMemberOf_Ini=("")
				$global:x_UserAlterarMemberOf = @{}
				$global:x_UserRefMemberOf_Ini=("")
				$global:x_UserRefMemberOf = @{}

				$global:x_UserAlterarMemberOf_Ini = Get-ADPrincipalGroupMembership $global:x_UserAlterar | sort name
				if ($global:x_UserAlterarMemberOf_Ini -eq $null)
				{
					Write-Host "`nUserID a alterar <$global:x_UserAlterar> não existe."
					exit
				}
				$global:x_UserRefMemberOf_Ini = Get-ADPrincipalGroupMembership $global:x_UserRef | sort name
				if ($global:x_UserRefMemberOf_Ini -eq $null)
				{
					Write-Host "`nUserID de referência <$global:x_UserRef> não existe."
					exit
				}
				$global:x_UserAlterarMemberOf_Ini | %{$global:x_UserAlterarMemberOf.add($_.name,(0,$_.distinguishedName)) }
				$global:x_UserRefMemberOf_Ini | %{$global:x_UserRefMemberOf.add($_.name,(0,$_.distinguishedName)) }
			} 

		"Set" {
				$global:x_UserAlterarMemberOf_Ini=("")
				$global:x_UserAlterarMemberOf = @{}
				$global:x_UserAlterarMemberOf_Ini = Get-ADPrincipalGroupMembership $global:x_UserAlterar | sort name
				if ($global:x_UserAlterarMemberOf_Ini -eq $null)
				{
					Write-Host "`nUserID a alterar <$global:x_UserAlterar> não existe."
					exit
				}
				$global:x_UserAlterarMemberOf_Ini | %{$global:x_UserAlterarMemberOf.add($_.name,(0,$_.distinguishedName)) }
			}
    }
}


Function MakeNewForm {
	$Form.Close()
	$Form.Dispose()
	MakeForm
}

Function ExecuteCmdSetReload {

	PreencherHashTables("AD")
	[System.Windows.Forms.MessageBox]::Show("Reload completo!", 'Info', 'Ok', 'Info')
	MakeNewForm
}


#
#   Estado dos grupos dentro da HASH Table
#
#   Estados superiores a 5, são para eliminar
#
#   Grupo com valor :
#		0 - Grupo lido directamente da AD e será mantido
#		1 - Grupo transferido do user de referência e será criado
#		2 - Grupo transferido do user de referência e mas já existia
#		9 - Grupo lido directamente da AD e será eliminado
#		8 - Grupo transferido do user de referência. Depois foi marcado para eliminado. Como não existe na AD não tem de ser eliminado.
#

Function ExecuteCmdSetRetirar {
	if (!$ListBoxUserAlterar.SelectedItems) {
		[System.Windows.Forms.MessageBox]::Show("Não seleccionou nenhum Grupo a retirar!", 'Critical', 'Ok', 'Error')
		return
	}
	$ListBoxUserAlterar.SelectedItems |	%{
											$x_Grupo = $_
											switch ($global:x_UserAlterarMemberOf[($x_Grupo)][0])
											{
												0
													{
													$global:x_UserAlterarMemberOf[($x_Grupo)][0] = 9
													}
												2
													{
													$global:x_UserAlterarMemberOf[($x_Grupo)][0] = 9
													}
												1
													{
													$global:x_UserAlterarMemberOf.Remove(($x_Grupo))
													}
											}
										}
	$global:x_Status = "Alterações pendentes ......"
	MakeNewForm
	
}

Function ExecuteCmdSetAdicionar {
	if (!$ListBoxUserRef.SelectedItems) {
		[System.Windows.Forms.MessageBox]::Show("Não seleccionou nenhum Grupo a adicionar!", 'Critical', 'Ok', 'Error')
		return
	}
	$ListBoxUserRef.SelectedItems |	%{
										if ($global:x_UserAlterarMemberOf.Contains($_))
										{
											$global:x_UserAlterarMemberOf[$_][0] = 2
											$global:x_UserAlterarMemberOf[$_][1] = $global:x_UserRefMemberOf[$_][1]
										} else
										{
											$global:x_UserAlterarMemberOf.add($_,(1,$global:x_UserRefMemberOf[$_][1]))
										}
										$global:x_UserRefMemberOf[$_][0] = 9
									}
	$global:x_Status = "Alterações pendentes ......"
	MakeNewForm
}

Function ExecuteCmdSet {

	 Invoke-Expression "D:\Scripts\AD\User_MemberOf.ps1 $global:x_UserAlterar"
	 $global:x_UserAlterarMemberOf.keys | %{
									$x_CN = $global:x_UserAlterarMemberOf[($_)][1]
									$x_Estado = $global:x_UserAlterarMemberOf[($_)][0]
									if ($x_Estado -eq 1)
										{
											Add-ADPrincipalGroupMembership $global:x_UserAlterar $x_CN
										}
									if ($x_Estado -eq 9)
										{
											Remove-ADPrincipalGroupMembership $global:x_UserAlterar $x_CN -Confirm:$false
										}
									}

	PreencherHashTables("Set")
	$global:x_Status = ""
	[System.Windows.Forms.MessageBox]::Show("Alterações efetuadas!", 'Info', 'Ok', 'Info')
	MakeNewForm 
}

Function MakeForm {

	$script:Form = New-Object system.Windows.Forms.Form
	$Form.Text = "Mudança Posto Trabalho - MemberOf"
	$Form.Size = New-Object System.Drawing.Size(645,580)
	$Form.StartPosition = "CenterScreen"

	$LabelUserAlterar = New-Object System.Windows.Forms.Label
	$LabelUserAlterar.Location = New-Object System.Drawing.Size(10,5) 
	$LabelUserAlterar.Size = New-Object System.Drawing.Size(260,15) 
	$LabelUserAlterar.Text = "UserID a Alterar: <" + $global:x_UserAlterar + ">"

	$LabelUserAlterarMemberOf = New-Object System.Windows.Forms.Label
	$LabelUserAlterarMemberOf.Location = New-Object System.Drawing.Size(10,20) 
	$LabelUserAlterarMemberOf.Size = New-Object System.Drawing.Size(260,15) 
	$LabelUserAlterarMemberOf.Text = "MemberOf"

	$ListBoxUserAlterar = New-Object System.Windows.Forms.ListBox
	$ListBoxUserAlterar.Location = New-Object System.Drawing.Size(10,35)
	$ListBoxUserAlterar.Size = New-Object System.Drawing.Size(260,120)
	$ListBoxUserAlterar.Height = 450
	$ListBoxUserAlterar.SelectionMode = "MultiExtended"
	$ListBoxUserAlterar.Sorted=$true
	$global:x_UserAlterarMemberOf.Keys | %{
									$x_ItemList = $_
									if ($global:x_UserAlterarMemberOf[($_)][0] -le 5) 
										{
										[void] $ListBoxUserAlterar.Items.Add($x_ItemList)
										}
									}

	$LabelUserRef = New-Object System.Windows.Forms.Label
	$LabelUserRef.Location = New-Object System.Drawing.Size(360,5) 
	$LabelUserRef.Size = New-Object System.Drawing.Size(260,15) 
	$LabelUserRef.Text = "UserID de Referência: <" + $global:x_UserRef + ">"

	$LabelUserRefMemberOf = New-Object System.Windows.Forms.Label
	$LabelUserRefMemberOf.Location = New-Object System.Drawing.Size(360,20) 
	$LabelUserRefMemberOf.Size = New-Object System.Drawing.Size(260,15) 
	$LabelUserRefMemberOf.Text = "MemberOf"

	$ListBoxUserRef = New-Object System.Windows.Forms.ListBox
	$ListBoxUserRef.Location = New-Object System.Drawing.Size(360,35)
	$ListBoxUserRef.Size = New-Object System.Drawing.Size(260,120)
	$ListBoxUserRef.Height = 450
	$ListBoxUserRef.SelectionMode = "MultiExtended"
	$ListBoxUserRef.Sorted=$true
	$global:x_UserRefMemberOf.Keys | %{
									$x_ItemList = $_
									if ($global:x_UserRefMemberOf[($_)][0] -le 5) 
										{
										[void] $ListBoxUserRef.Items.Add($x_ItemList)
										}
									}

	$ButtonSetRetirar = New-Object System.Windows.Forms.Button
	$ButtonSetRetirar.Location = New-Object System.Drawing.Size(280,60)
	$ButtonSetRetirar.Size = New-Object System.Drawing.Size(60,20)
	$ButtonSetRetirar.Text = "( X )"
	$ButtonSetRetirar.Add_Click({ExecuteCmdSetRetirar})

	$ButtonSetAdicionar = New-Object System.Windows.Forms.Button
	$ButtonSetAdicionar.Location = New-Object System.Drawing.Size(280,90)
	$ButtonSetAdicionar.Size = New-Object System.Drawing.Size(60,20)
	$ButtonSetAdicionar.Text = "<<<"
	$ButtonSetAdicionar.Add_Click({ExecuteCmdSetAdicionar})

	$ButtonSet = New-Object System.Windows.Forms.Button
	$ButtonSet.Location = New-Object System.Drawing.Size(210,490)
	$ButtonSet.Size = New-Object System.Drawing.Size(60,20)
	$ButtonSet.Text = "Set"
	$ButtonSet.Add_Click({ExecuteCmdSet})

	$ButtonReload = New-Object System.Windows.Forms.Button
	$ButtonReload.Location = New-Object System.Drawing.Size(360,490)
	$ButtonReload.Size = New-Object System.Drawing.Size(60,20)
	$ButtonReload.Text = "Reload"
	$ButtonReload.Add_Click({ExecuteCmdSetReload})

	$LabelStatus = New-Object System.Windows.Forms.Label
	$LabelStatus.Location = New-Object System.Drawing.Size(10,515) 
	$LabelStatus.Size = New-Object System.Drawing.Size(610,15) 
	$LabelStatus.Text = $global:x_Status
	$LabelStatus.BorderStyle = 1

	$Form.Controls.Add($LabelUserAlterar)
	$Form.Controls.Add($LabelUserAlterarMemberOf)
	$Form.Controls.Add($ListBoxUserAlterar)

	$Form.Controls.Add($LabelUserRef)
	$Form.Controls.Add($LabelUserRefMemberOf)
	$Form.Controls.Add($ListBoxUserRef)

	$Form.Controls.Add($ButtonSetRetirar)
	$Form.Controls.Add($ButtonSetAdicionar)
	$Form.Controls.Add($ButtonSet)
	$Form.Controls.Add($ButtonReload)
	$Form.Controls.Add($LabelStatus)
	$Form.ShowDialog()
}

#
#    Inicio do Corpo Principal do Programa
#

# ## Inicio  Teste parametros entrada

if ($PSBoundParameters.keys.count -eq 2)
{
	$global:x_UserAlterar = $PSBoundParameters["p1"]
	$global:x_UserRef = $PSBoundParameters["p2"]
}else
{
	$global:x_UserAlterar = $UserName 
	$global:x_UserRef = $UserNametemplate
}

if ($global:x_UserAlterar -eq $null -or $global:x_UserAlterar -le "      " )
{
	Write-Host "`nÉ necessário indicar um UserID a alterar."
	exit
}

if ($global:x_UserRef -eq $null -or $global:x_UserRef -le "      " )
{
	Write-Host "`nÉ necessário indicar um UserID de referência."
	exit
}
# ## Fim  Teste parametros entrada

$global:x_Status=""
PreencherHashTables("AD")

MakeForm
#endregion


$ADUser = Get-AdUser $UserName -Properties HomeDirectory
$ADUser.HomeDirectory | Write-Output
$text = $ADUser.HomeDirectory | Write-Output 
$ADUsertpl = Get-AdUser $UserNametemplate -Properties HomeDirectory
$ADUsertpl.HomeDirectory | Write-Output
$tmldir= $ADUsertpl.HomeDirectory | Write-Output
$stringa =   $tmldir
$x= $stringa.Substring(0,$stringa.Length-7)
$novapath = "$x$UserName"
Write-Host "Copy $text  to  $novapath "
Copy-Item $text  -Recurse -Destination $novapath -Force
$renHomeDir = "_$UserName"
Write-Host Rename $ADUser.HomeDirectory to $renHomeDir
Rename-Item -Path $ADUser.HomeDirectory -NewName $renHomeDir
set-aduser $UserName -homedirectory $novapath
$HomeFolders=$novapath
Foreach ($Folder in $HomeFolders)
{

$Username= $UserName
 
$Access=GET-ACL $Folder
 
$FileSystemRights=[System.Security.AccessControl.FileSystemRights]"Modify"
$AccessControlType=[System.Security.AccessControl.AccessControlType]"Allow"
$InheritanceFlags=[System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
$PropagationFlags=[System.Security.AccessControl.PropagationFlags]"InheritOnly"
$IdentityReference=$Username

$FileSystemAccessRule=New-Object System.Security.AccessControl.FileSystemAccessRule ($IdentityReference, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
 
$Access.AddAccessRule($FileSystemAccessRule)
 
 SET-ACL $Folder $Access
  
}
 

Write-Output "FUNC Move Utilzador de OU" 
$oldou = get-aduser $UserNametemplate -Properties DistinguishedName | select  DistinguishedName 
$oldou1 =  $oldou.DistinguishedName | Write-Output
$a = $oldou1
$newou = $a.substring(11) 
Get-ADUser $UserName| Move-ADObject -TargetPath $newou
Write-Output "Finnish FUNC Move Utilzador de OU"
Write-host  "Processo Terminado" -ForegroundColor Green

}
 
 Stop-Transcript   
}



function Remove-DNSRecord
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        PCS-DNS
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        PCS-DNS
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $NodeToDelete = (read-host "Dns a Remover")
    )
    
    
    $DNSServer = "spf6001dcs11.fidelidademundial.com"
    $ZoneName = "fidelidademundial.com"
    $NodeDNS = $null
    $NodeDNS = Get-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DNSServer -Node $NodeToDelete -RRType A -ErrorAction SilentlyContinue
    if($NodeDNS -eq $null){
        Write-Host "No DNS record found" -ForegroundColor red
    } else {
        Remove-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DNSServer -InputObject $NodeDNS -Force
        write-host "Registo de DNS $NodeToDelete Removido" -ForegroundColor green
    }
    
   
}


function Add-user2grp
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        Add-user2grp
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        Add-user2grp
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $grp = (Read-Host 'Grupo'),
        
        [Parameter(Mandatory=$false, Position=1)]
        [Object]
        $usr = (Read-host 'user')
    )
    
    Add-ADGroupMember -Identity $grp -Members $usr
    
    
    Get-ADPrincipalGroupMembership -Identity $usr | select name |  Where-Object { $_.Name -like $grp }
}



function Add-sasAdHoc
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        PCS-ADDNET
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        PCS-ADDNET
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $user = (Read-Host Username)
    )
    
    Add-ADGroupMember -Identity D-SASGUIDE4-S -Members $user -Confirm:$false
    
   
    
    
    Get-ADPrincipalGroupMembership $user | select name
}


function add-localadmin {
[CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $User = (Read-Host 'User'),
        [Parameter(Mandatory=$false, Position=1)]
        [Object]
        $Maquina = (Read-host 'Cname')
    )

	Add-ADGroupMember -Identity GADM-PowerUser -Members $User
	
    Set-ADComputer -Identity $Maquina  -replace @{employeeNumber="$User"}
}


$xoutput = @"
"********************************
PCS-SDM - Module Help  
**********************************************************************************
Version: $PCSver 
Deployed: $PCSDeploydate By Frederico Frazão
***********************************************************************************
AD Tools User and Groups:

GET-USERSCRIADOS    - Listagem de Users Criados (GET-USERSCRIADOS F082522 F082522)
Add-Net-grp	        - Adiciona o Grupo G-AcessoInternet (Add-Net-grp User)
Add-Rassis  	    - Adiciona o Grupo D-FacetsIB-S (D-FacetsIB-S  User)
Del-ADuser          - Remove User da AD (del-ADuser -chg 424199 -xnuc ex01941)
Find-grp            - Busca de grupo por Wildcard (Find-grp *cad*)
Get-Member_of		- Compara grupos de user + user de Ref. 
Move-Utilizador		- Move user entre direções
Add-user2grp        - Adicionar user a grupo
Add-sasAdHoc        - Adicionar user Query Ad-Hoc = SASGUIDE
add-localadmin      - Adicionar User como Local admin (Add-localadmin -User x333867 -Maquina FMN5OUTRCW3035)
Export-memberof     - exportar membros de um grupo (Export-memberof -p1 GDCI-DIN-DCT-W)

DNS Tools:
Update-DNSRecord	- Actualiza Entrada DNS (Update-DNSRecord -novoip 10.0.0.0 -NodeTouPDATE Batatas)
Remove-DNSRecord 	 - Remove Entrade de DNS  (Remove-DNSEntry "DNS TO REMOVE")


Forensics Tools:
GET-REBOOTS - Listagem de Reboots ( GET-REBOOTS ServerName)

	
	 
Deployment Tools:
Dep-Clean-SCOM-CACHE   - Limpa Cache Agente SCOM
Dep-Rename-Nic		  - Rename Nic para FE
Dep-Remove-CN  	 	  - Remove CN da AD  (ACP-Remove-CN Cname)
Dep-Rename-CN  	 	  - Rename CN (ACP-Rename-CN Novo_CN)
Dep-Install-WinUpdates - Instala Windows Updates 
	 
" 
"@

