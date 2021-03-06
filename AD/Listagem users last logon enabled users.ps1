Import-Module ActiveDirectory
Get-ADUser -Filter {Enabled -eq $true} -SearchBase "OU=HPP-CASCAIS,DC=fidelidademundial,DC=com" -properties  sAMAccountName,DisplayName,department,company,whenCreated,LastLogontimestamp | 
Select-Object sAMAccountName,DisplayName,department,company,whenCreated,@{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogontimestamp)}}|FT #| `
#Export-Csv c:\temp\usersHPPCascais.csv -encoding UTF8 -notypeinformation -noclobber -delimiter ";"