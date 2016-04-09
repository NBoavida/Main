Function LUC(){
    param(
        [Parameter(Mandatory=$true)][string]$UserIni,
        [Parameter(Mandatory=$false)][string]$UserFim
    )
    if(!($UserFim)){
        $UserFim = "EX09999"
    }

	$filtro= '-filter {name -ge "' + $UserIni + '" -and name -le "' + $UserFim + '"}'
	$cmd = "get-mailbox $filtro"
	invoke-expression $cmd |
		select @{name="UserID"; expression={$_.name}}, @{name="Nome"; expression={$_.displayname}}, @{name="email"; expression={$_.windowsemailaddress}}, @{name="Password"; expression={"654321a*"}} |
		fl
}