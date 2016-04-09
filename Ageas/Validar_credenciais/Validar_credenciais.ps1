
$cred = Get-Credential 
 $username = $cred.username
 $password = $cred.GetNetworkCredential().password


 $CurrentDomain = "LDAP://" + ([ADSI]"").distinguishedName
 $domain = New-Object System.DirectoryServices.DirectoryEntry($CurrentDomain,$UserName,$Password)

if ($domain.name -eq $null)
{
 write-host "Autenticação falhada, validar username e password"
		#[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
[void][System.Windows.Forms.MessageBox]::Show("Autenticação falhada, validar username e password","Doit IT TOOL")
 exit 
}
else
{
 write-host "$username Autenticado com Sucesso em bcpcorp.dev"
		#[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
[void][System.Windows.Forms.MessageBox]::Show("$username Autenticado com Sucesso em bcpcorp.dev","Doit IT TOOL")
 
}
	
