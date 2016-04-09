$user = Read-Host Username
Add-ADGroupMember -Identity G-AcessoInternet -Members $user

Remove-ADGroupMember  G-AcessoIntranet -Members $user  -ErrorAction SilentlyContinue


Get-ADPrincipalGroupMembership $user | select name