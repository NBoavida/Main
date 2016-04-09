# Add Exchange 2007 commandlets (if not added)
if(!(Get-PSSnapin | 
    Where-Object {$_.name -eq "Microsoft.Exchange.Management.PowerShell.Admin"})) {
      ADD-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
    }

$UserIni = Read-Host 'Qual o UserID... inicial?'
$UserFim = Read-Host 'Qual o UserID... final?'
$filtro= '-filter {name -ge "' + $UserIni + '" -and name -le "' + $UserFim + '"}'
#"$filtro"
$cmd = "get-mailbox $filtro"
#"$cmd"
invoke-expression $cmd | 
select @{name="UserID"; expression={$_.name}}, @{name="Nome"; expression={$_.displayname}}, @{name="email"; expression={$_.windowsemailaddress}}, @{name="Password"; expression={"654321a*"}} | 
fl
