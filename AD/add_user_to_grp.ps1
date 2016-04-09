

#D-AS400IB-S
$grp1= 'D-AS400InfoIB-S'
$grp1= 'D-AS400ProdIB-S'
$grp= 'D-AS400ProdTPIB-S'

$usr = 'F071880'



Add-ADGroupMember -Identity $grp -Members $usr


Get-ADPrincipalGroupMembership -Identity $usr | select name |  Where-Object { $_.Name -like $grp }


