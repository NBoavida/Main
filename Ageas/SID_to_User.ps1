param($p1)

if ($PSBoundParameters.keys.count -eq 1)
{
	$x_Sid = $PSBoundParameters["p1"]
}else
{
 
$x_Sid = READ-HOST $args 
}

if ($x_Sid -eq $null -or $x_Sid -le "      " )
{
	Write-Host "`� necess�rio indicar um SID a converter."
	exit
}


$objSID = New-Object System.Security.Principal.SecurityIdentifier ($x_Sid) 
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount]) 
$objUser.Value 


