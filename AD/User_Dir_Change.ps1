param($p1, $p2)
cls
Add-Type -AssemblyName System.Windows.Forms

Function Add-Node($Nodes, $Path, $Tag) {  
    $Path.Split("/") | % {
        Write-Verbose "Searching For: $_"
        $SearchResult = $Nodes.Find($_, $False)

    If ($SearchResult.Count -eq 1) {
      Write-Verbose "Selecting: $($SearchResult.Name)"
      $Nodes = $SearchResult[0].Nodes
    }
    Else {
      Write-Verbose "Adding: $_"
      $Node = New-Object Windows.Forms.TreeNode($_)
      $Node.Name = $_
	  $Node.Tag = $Tag
      $Nodes.Add($Node)  | Out-Null
    }
  }
}

Function Add-Node-OUs($Nodes, $OUIni) {
	$OUIni_Detalhe = Get-ADOrganizationalUnit -identity $OUIni -properties *| select Name, CanonicalName, DistinguishedName
	Add-Node $Nodes $OUIni_Detalhe.CanonicalName $OUIni_Detalhe.DistinguishedName
	$OU1Nivel = Get-OU($OUIni)
	$OU1Nivel | %{Add-Node $Nodes $_.CanonicalName $_.DistinguishedName}
	$OU1Nivel.DistinguishedName | %{
		if ($_ -ne $null) {
			$OU2Nivel = Get-OU($_)
			$OU2Nivel | %{Add-Node $Nodes $_.CanonicalName $_.DistinguishedName}
			$OU2Nivel.DistinguishedName | %{
				if ($_ -ne $null) {
					$OU3Nivel = Get-OU($_)
					$OU3Nivel | %{Add-Node $Nodes $_.CanonicalName $_.DistinguishedName}
					$OU3Nivel.DistinguishedName | %{
						if ($_ -ne $null) {
							$OU4Nivel = Get-OU($_)
							$OU4Nivel | %{Add-Node $Nodes $_.CanonicalName $_.DistinguishedName}
							}
						}
					}
				}
			}
		}
}

function Get-OU($OU) {
	$x_OUs=Get-ADOrganizationalUnit -filter * -SearchBase $OU -SearchScope 1 -properties *| select Name, CanonicalName, DistinguishedName
	return $x_OUs 
}

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

Function ExecuteCmdReload {

	PreencherHashTables("AD")
	$global:x_UserAlterarDistNameDestino=""
	$global:x_Status = ""
	[System.Windows.Forms.MessageBox]::Show("Reload completo!", 'Info', 'Ok', 'Info')
	MakeNewForm
}

Function ExecuteAfterSelectOU ($x_Tag, $x_Text, $x_Name, $x_FullPath) {
	write-host "AfterSelect OU"
	write-host "A:<$a>`nBA:<$b>`nC:<$c>`nD:<$d>`n"
}

Function ExecuteAfterCheckOU {
	write-host "AfterCheck OU"
	write-host "Tag:<$_.Node.tag>"
	write-host "FullPath:<$_.Node.FullPath>"
	write-host "Level:<$_.Node.Level>"
}

Function ExecuteCmdClickOU {
	write-host "Click OU"
	#write-host "SelectedNodeTag:<$_.Node.Tag>" 
	#write-host "SelectedNodeFullPath:<$TV.SelectedNode.Nodes.FullPath>" 
	#write-host "SelectedNodeLevel:<$TV.SelectedNode.Nodes.Level>" 
}

Function ExecuteNodeMouseClick {
	write-host "NodeMouseClick"
	$_ | fl
}

Function ExecuteCmdDblClickOU {
	write-host "Double Click OU"

}

Function FromBrowseOU {

	$script:FormOU = New-Object system.Windows.Forms.Form
	$FormOU.Text = "Browse OU"
	$FormOU.Size = New-Object System.Drawing.Size(400,550)
	$FormOU.StartPosition = "CenterScreen"
	$FormOU.FormBorderStyle = 'Fixed3D'
	
	$TV = new-object windows.forms.TreeView
	$TV.Location = new-object System.Drawing.Size(10,10)
	$TV.size = new-object System.Drawing.Size(365,495)
	$TV.Anchor = "top, left, right" 
	
    # Root Domain
	Add-Node $TV.Nodes "fidelidademundial.com" "DC=fidelidademundial,DC=com"  
    # Node Empresas
	Add-Node-OUs $TV.Nodes "OU=Utilizadores,OU=AgenciasClientes,OU=Agencias,OU=FM,DC=fidelidademundial,DC=com"
	Add-Node-OUs $TV.Nodes "OU=Utilizadores,OU=CentrosMediadores,OU=Agencias,OU=FM,DC=fidelidademundial,DC=com"
	Add-Node-OUs $TV.Nodes "OU=Utilizadores,OU=Servicos-Centrais,OU=FM,DC=fidelidademundial,DC=com"
#	Add-Node-OUs $TV.Nodes "OU=FM,DC=fidelidademundial,DC=com"
#	Add-Node-OUs $TV.Nodes "OU=FPE,DC=fidelidademundial,DC=com"
#	Add-Node-OUs $TV.Nodes "OU=Multicare,DC=fidelidademundial,DC=com"
#	Add-Node-OUs $TV.Nodes "OU=ViaDirecta,DC=fidelidademundial,DC=com"
	
	$TV.Nodes.ExpandAll()
	
	#$TV.CheckBoxes = $true
	$TV.Nodes
	
	#$TV.Add_Click({ExecuteCmdClickOU})
	#$TV.Add_Click({write-host "Click:$TV"})
	#$TV.Add_AfterSelect({(ExecuteAfterSelectOU $_.Node.Tag $_.Node.Text $_.Node.Name $_.Node.FullPath)})
	#$TV.Add_AfterSelect({$x_Tag=$_.Node.Tag;$x_Text=$_.Node.Text;$x_Name=$_.Node.Name;$x_FullPath=$_.Node.FullPath;write-host "Tag:<$x_Tag>`nText:<$x_Text>`nName:<$x_Name>`nFullPath:<$x_FullPath>"})
	#$TV.add_AfterCheck({ExecuteAfterCheckOU}) 
	#$TV.Add_DoubleClick({ExecuteCmdDblClickOU})
	##$TV.Add_NodeMouseClick({write-host "NodeMouseClick:$TV.Tag"})
	#$TV.Add_NodeMouseClick({ExecuteNodeMouseClick})
	$TV.Add_NodeMouseDoubleClick({$TxtBoxUserAlterarDistNameDestino.Text = $_.Node.Tag; $global:x_UserAlterarDistNameDestino = $_.Node.Tag})
	
	$FormOU.Controls.Add($TV)
	$FormOU.ShowDialog()
	
}

Function ExecuteCmdBrowseOU {

	FromBrowseOU
	
	#$global:x_UserAlterarDistNameDestino = "Teste"
	#$global:x_Status += " + OU destino alterada"
	#MakeNewForm
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

Function ExecuteCmdRetirar {
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
	$global:x_Status += " + Grupos alterados"
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
	$global:x_Status += " + Grupos alterados"
	MakeNewForm
}

Function ExecuteCmdSet {
	#Backup MemberOf do UserID (Grupos AD)
	$global:x_User_Dir_Change = "D:\Scripts\AD\User_Dir_Change\"
	Invoke-Expression "D:\Scripts\AD\User_MemberOf.ps1 $global:x_UserAlterar $global:x_User_Dir_Change"

	
	Set-ADUser -identity $global:x_UserAlterar -DisplayName $TxtBoxUserAlterarDName.Text -HomeDirectory $TxtBoxUserAlterarHomeF.Text 
	#$TxtBoxUserAlterarDistName.Text
	
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
	$Form.Text = "Mudança Posto Trabalho"
	$Form.Size = New-Object System.Drawing.Size(1100,615)
	$Form.StartPosition = "CenterScreen"
	$Form.FormBorderStyle = 'Fixed3D'

	$x_Center = $Form.Size.Width / 2
	$x_Col1_H = 10
	$x_Col2_H = 585
	
	$LabelUserAlterar = New-Object System.Windows.Forms.Label
	$LabelUserAlterar.Location = New-Object System.Drawing.Size($x_Col1_H,5) 
	$LabelUserAlterar.Size = New-Object System.Drawing.Size(390,15) 
	$LabelUserAlterar.Text = "UserID a Alterar: <" + $global:x_UserAlterar + ">"
	$Form.Controls.Add($LabelUserAlterar)
	
	$LabelUserAlterarDName = New-Object System.Windows.Forms.Label
	$LabelUserAlterarDName.Location = New-Object System.Drawing.Size($x_Col1_H,25) 
	$LabelUserAlterarDName.Size = New-Object System.Drawing.Size(80,15) 
	$LabelUserAlterarDName.Text = "Display name:"
	$Form.Controls.Add($LabelUserAlterarDName)
	
	$TxtBoxUserAlterarDName = New-Object System.Windows.Forms.TextBox 
	$TxtBoxUserAlterarDName.Location = New-Object System.Drawing.Size(($x_Col1_H + 80),(25 - 5)) 
	$TxtBoxUserAlterarDName.Size = New-Object System.Drawing.Size(410,15) 
	$TxtBoxUserAlterarDName.Text = (Get-ADUser -identity $global:x_UserAlterar -Properties Displayname).DisplayName
	$Form.Controls.Add($TxtBoxUserAlterarDName)
	
	$LabelUserAlterarHomeF = New-Object System.Windows.Forms.Label
	$LabelUserAlterarHomeF.Location = New-Object System.Drawing.Size($x_Col1_H,45) 
	$LabelUserAlterarHomeF.Size = New-Object System.Drawing.Size(80,15) 
	$LabelUserAlterarHomeF.Text = "Home Folder:"
	$Form.Controls.Add($LabelUserAlterarHomeF)
	
	$TxtBoxUserAlterarHomeF = New-Object System.Windows.Forms.TextBox 
	$TxtBoxUserAlterarHomeF.Location = New-Object System.Drawing.Size(($x_Col1_H + 80),(45 - 5)) 
	$TxtBoxUserAlterarHomeF.Size = New-Object System.Drawing.Size(410,15) 
	$TxtBoxUserAlterarHomeF.Text = (Get-ADUser -identity $global:x_UserAlterar -Properties HomeDirectory).HomeDirectory
	$Form.Controls.Add($TxtBoxUserAlterarHomeF)
		
	$LabelUserAlterarDistName = New-Object System.Windows.Forms.Label
	$LabelUserAlterarDistName.Location = New-Object System.Drawing.Size($x_Col1_H,65) 
	$LabelUserAlterarDistName.Size = New-Object System.Drawing.Size(80,15) 
	$LabelUserAlterarDistName.Text = "Disting.Name:"
	$Form.Controls.Add($LabelUserAlterarDistName)
	
	$TxtBoxUserAlterarDistName = New-Object System.Windows.Forms.TextBox 
	$TxtBoxUserAlterarDistName.Location = New-Object System.Drawing.Size(($x_Col1_H + 80),(65 - 5)) 
	$TxtBoxUserAlterarDistName.Size = New-Object System.Drawing.Size(410,15) 
	$TxtBoxUserAlterarDistName.Text = (Get-ADUser -identity $global:x_UserAlterar -Properties distinguishedName).distinguishedName
	$Form.Controls.Add($TxtBoxUserAlterarDistName)
		
	$LabelUserAlterarDistNameDestino = New-Object System.Windows.Forms.Label
	$LabelUserAlterarDistNameDestino.Location = New-Object System.Drawing.Size($x_Col1_H,85) 
	$LabelUserAlterarDistNameDestino.Size = New-Object System.Drawing.Size(80,15) 
	$LabelUserAlterarDistNameDestino.Text = "OU Destino:"
	$Form.Controls.Add($LabelUserAlterarDistNameDestino)
	
	$TxtBoxUserAlterarDistNameDestino = New-Object System.Windows.Forms.TextBox 
	$TxtBoxUserAlterarDistNameDestino.Location = New-Object System.Drawing.Size(($x_Col1_H + 80),(85 - 5)) 
	$TxtBoxUserAlterarDistNameDestino.Size = New-Object System.Drawing.Size(410,15) 
	$TxtBoxUserAlterarDistNameDestino.Text = ((Get-ADUser -identity $global:x_UserRef -Properties distinguishedName).distinguishedName  -split(",",2))[1]
	$Form.Controls.Add($TxtBoxUserAlterarDistNameDestino)
	
	$LabelUserAlterarMemberOf = New-Object System.Windows.Forms.Label
	$LabelUserAlterarMemberOf.Location = New-Object System.Drawing.Size($x_Col1_H,105) 
	$LabelUserAlterarMemberOf.Size = New-Object System.Drawing.Size(390,15) 
	$LabelUserAlterarMemberOf.Text = "MemberOf"
	$Form.Controls.Add($LabelUserAlterarMemberOf)

	$ListBoxUserAlterar = New-Object System.Windows.Forms.ListBox
	$ListBoxUserAlterar.Location = New-Object System.Drawing.Size($x_Col1_H,120)
	$ListBoxUserAlterar.Size = New-Object System.Drawing.Size(490,85)
	$ListBoxUserAlterar.Height = 400
	$ListBoxUserAlterar.SelectionMode = "MultiExtended"
	$ListBoxUserAlterar.Sorted=$true
	$global:x_UserAlterarMemberOf.Keys | %{
									$x_ItemList = $_
									if ($global:x_UserAlterarMemberOf[($_)][0] -le 5) 
										{
										[void] $ListBoxUserAlterar.Items.Add($x_ItemList)
										}
									}
	$Form.Controls.Add($ListBoxUserAlterar)

	$LabelUserRef = New-Object System.Windows.Forms.Label
	$LabelUserRef.Location = New-Object System.Drawing.Size($x_Col2_H,5) 
	$LabelUserRef.Size = New-Object System.Drawing.Size(390,15) 
	$LabelUserRef.Text = "UserID de Referência: <" + $global:x_UserRef + ">"
	$Form.Controls.Add($LabelUserRef)

	$LabelUserRefDName = New-Object System.Windows.Forms.Label
	$LabelUserRefDName.Location = New-Object System.Drawing.Size($x_Col2_H,25) 
	$LabelUserRefDName.Size = New-Object System.Drawing.Size(80,15) 
	$LabelUserRefDName.Text = "Display name:"
	$Form.Controls.Add($LabelUserRefDName)
	
	$TxtBoxUserRefDName = New-Object System.Windows.Forms.TextBox 
	$TxtBoxUserRefDName.Location = New-Object System.Drawing.Size(($x_Col2_H + 80),(25 - 5)) 
	$TxtBoxUserRefDName.Size = New-Object System.Drawing.Size(410,15) 
	$TxtBoxUserRefDName.Text = (Get-ADUser -identity $global:x_UserRef -Properties Displayname).DisplayName
	$TxtBoxUserRefDName.ReadOnly = $true
	$Form.Controls.Add($TxtBoxUserRefDName)
	
	$LabelUserRefHomeF = New-Object System.Windows.Forms.Label
	$LabelUserRefHomeF.Location = New-Object System.Drawing.Size($x_Col2_H,45) 
	$LabelUserRefHomeF.Size = New-Object System.Drawing.Size(80,15) 
	$LabelUserRefHomeF.Text = "Home Folder:"
	$Form.Controls.Add($LabelUserRefHomeF)
	
	$TxtBoxUserRefHomeF = New-Object System.Windows.Forms.TextBox 
	$TxtBoxUserRefHomeF.Location = New-Object System.Drawing.Size(($x_Col2_H + 80),(45 - 5)) 
	$TxtBoxUserRefHomeF.Size = New-Object System.Drawing.Size(410,15) 
	$TxtBoxUserRefHomeF.Text = (Get-ADUser -identity $global:x_UserRef -Properties HomeDirectory).HomeDirectory
	$TxtBoxUserRefHomeF.ReadOnly = $true
	$Form.Controls.Add($TxtBoxUserRefHomeF)
	
	$LabelUserRefDistName = New-Object System.Windows.Forms.Label
	$LabelUserRefDistName.Location = New-Object System.Drawing.Size($x_Col2_H,65) 
	$LabelUserRefDistName.Size = New-Object System.Drawing.Size(80,15) 
	$LabelUserRefDistName.Text = "Disting.Name:"
	$Form.Controls.Add($LabelUserRefDistName)
	
	$TxtBoxUserRefDistName = New-Object System.Windows.Forms.TextBox 
	$TxtBoxUserRefDistName.Location = New-Object System.Drawing.Size(($x_Col2_H + 80),(65 - 5)) 
	$TxtBoxUserRefDistName.Size = New-Object System.Drawing.Size(410,15) 
	$TxtBoxUserRefDistName.Text = (Get-ADUser -identity $global:x_UserRef -Properties distinguishedName).distinguishedName
	$TxtBoxUserRefDistName.ReadOnly = $true
	$Form.Controls.Add($TxtBoxUserRefDistName)
	
	$LabelUserRefMemberOf = New-Object System.Windows.Forms.Label
	$LabelUserRefMemberOf.Location = New-Object System.Drawing.Size($x_Col2_H,105) 
	$LabelUserRefMemberOf.Size = New-Object System.Drawing.Size(390,15) 
	$LabelUserRefMemberOf.Text = "MemberOf"
	$Form.Controls.Add($LabelUserRefMemberOf)

	$ListBoxUserRef = New-Object System.Windows.Forms.ListBox
	$ListBoxUserRef.Location = New-Object System.Drawing.Size($x_Col2_H,120)
	$ListBoxUserRef.Size = New-Object System.Drawing.Size(490,105)
	$ListBoxUserRef.Height = 400
	$ListBoxUserRef.SelectionMode = "MultiExtended"
	$ListBoxUserRef.Sorted=$true
	$global:x_UserRefMemberOf.Keys | %{
									$x_ItemList = $_
									if ($global:x_UserRefMemberOf[($_)][0] -le 5) 
										{
										[void] $ListBoxUserRef.Items.Add($x_ItemList)
										}
									}
	$Form.Controls.Add($ListBoxUserRef)

	$ButtonBrowsetOU = New-Object System.Windows.Forms.Button
	$ButtonBrowsetOU.Location = New-Object System.Drawing.Size(($x_Center - 47),80)
	$ButtonBrowsetOU.Size = New-Object System.Drawing.Size(30,20)
	$ButtonBrowsetOU.Text = "..."
	$ButtonBrowsetOU.Add_Click({ExecuteCmdBrowseOU})
	$Form.Controls.Add($ButtonBrowsetOU)

	$ButtonSetRetirar = New-Object System.Windows.Forms.Button
	$ButtonSetRetirar.Location = New-Object System.Drawing.Size(($x_Center - 37),125)
	$ButtonSetRetirar.Size = New-Object System.Drawing.Size(60,20)
	$ButtonSetRetirar.Text = "( X )"
	$ButtonSetRetirar.Add_Click({ExecuteCmdRetirar})
	$Form.Controls.Add($ButtonSetRetirar)

	$ButtonSetAdicionar = New-Object System.Windows.Forms.Button
	$ButtonSetAdicionar.Location = New-Object System.Drawing.Size(($x_Center - 37),150)
	$ButtonSetAdicionar.Size = New-Object System.Drawing.Size(60,20)
	$ButtonSetAdicionar.Text = "<<<"
	$ButtonSetAdicionar.Add_Click({ExecuteCmdSetAdicionar})
	$Form.Controls.Add($ButtonSetAdicionar)

	$ButtonSet = New-Object System.Windows.Forms.Button
	$ButtonSet.Location = New-Object System.Drawing.Size(440,525)
	$ButtonSet.Size = New-Object System.Drawing.Size(60,20)
	$ButtonSet.Text = "Set"
	$ButtonSet.Add_Click({ExecuteCmdSet})
	$Form.Controls.Add($ButtonSet)

	$ButtonReload = New-Object System.Windows.Forms.Button
	$ButtonReload.Location = New-Object System.Drawing.Size($x_Col2_H,525)
	$ButtonReload.Size = New-Object System.Drawing.Size(60,20)
	$ButtonReload.Text = "Reload"
	$ButtonReload.Add_Click({ExecuteCmdReload})
	$Form.Controls.Add($ButtonReload)

	$LabelStatus = New-Object System.Windows.Forms.Label
	$LabelStatus.Location = New-Object System.Drawing.Size($x_Col1_H,550) 
	$LabelStatus.Size = New-Object System.Drawing.Size(($Form.Size.Width - 35),15) 
	$LabelStatus.Text = $global:x_Status
	$LabelStatus.BorderStyle = 1
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
	$global:x_UserAlterar = 	Read-Host 'UserId a alterar?'
	$global:x_UserRef = 		Read-Host 'UserID de referência?'
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
