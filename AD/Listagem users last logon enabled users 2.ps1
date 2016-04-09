Import-Module ActiveDirectory
Get-ADUser -Filter {samaccountname -like "X910157"} -SearchBase "OU=FM,DC=fidelidademundial,DC=com" -properties  sAMAccountName,Enabled,EmployeeID,DisplayName,LastLogontimestamp | Select-Object sAMAccountName,Enabled,EmployeeID,DisplayName,@{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogontimestamp)}}| Export-Csv -path c:\temp\UsersFM.csv -encoding "unicode" -notypeinformation -noclobber -delimiter ";"