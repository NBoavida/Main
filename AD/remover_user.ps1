

#Var
$chg = Read-Host Change_ID 
$xnuc = Read-host Username Para Apagar
$discricao = get-aduser $xnuc -Properties Description | select  Description 
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