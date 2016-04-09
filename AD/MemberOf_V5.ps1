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
