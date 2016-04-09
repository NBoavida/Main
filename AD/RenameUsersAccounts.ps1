[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$NEW_Username,
	
   [Parameter(Mandatory=$True,Position=2)]
   [string]$OLD_Username
)

Import-Module activedirectory

Get-ADUser -Identity $OLD_Username -Properties samaccountname,displayname | Select-Object SamAccountName,DisplayName | Format-Table -AutoSize

Write-Host ""
Write-Host "Do you want to rename this user? (Y/N) " -ForegroundColor Yellow -NoNewline

$UserImnput = Read-Host

If($UserImnput -ieq "y")
{
	$NewUPN = $NEW_Username+"@fidelidademundial.com"
	
	$User2Rename = Get-ADUser -Identity $OLD_Username 
	
	Set-ADUser -Identity $User2Rename -SamAccountName $NEW_Username -UserPrincipalName $NewUPN
	
	$User2Rename = Get-ADUser -Identity $NEW_Username 
	
	Rename-ADObject -Identity $User2Rename -NewName $NEW_Username

	Start-Sleep -s 30

	Set-mailbox -identity $NEW_Username -Alias $NEW_Username

	$User2RenameMBX = Get-Mailbox -identity $NEW_Username

	$User2RenameMBX.EmailAddresses.Add("$NEW_Username@fidelidademundial.com")

	$User2RenameMBX.EmailAddresses.Remove("$OLD_Username@fidelidademundial.com")

	$User2RenameMBX | Set-Mailbox

}
Elseif($UserImnput -ieq "n")
{
	Write-Host "This script will terminate by your decision, without any action." -ForegroundColor Red
}
Else
{
	Write-Host "Unknown answer. This script will terminate." -ForegroundColor Red
}
