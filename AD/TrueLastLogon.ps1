import-module activedirectory 

$domain = "fidelidademundial.com" 

$myForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest() 
$domaincontrollers = $myforest.Sites | % { $_.Servers } | Select Name 
$RealUserLastLogon = $null 
$LastusedDC = $null 
$domainsuffix = "*."+$domain

$UserAccountsList = Get-ADUser -Filter {(SamAccountName -like "*")} -SearchBase "OU=FM,DC=Fidelidademundial,DC=com" -Properties SamAccountName,Enabled,EmployeeID,DisplayName

ForEach($UserAccount in $UserAccountsList)
{
	$samaccountname = $UserAccount.SamAccountName
	$UserEnabled = $UserAccount.Enabled
	$UserEmployeeID = $UserAccount.EmployeeID
	$UserDisplayName = $UserAccount.DisplayName
	
	foreach ($DomainController in $DomainControllers)  
	{ 
	    if ($DomainController.Name -like $domainsuffix ) 
	    { 
	        $UserLastlogon = Get-ADUser -Identity $samaccountname -Properties LastLogon -Server $DomainController.Name 
	        if ($RealUserLastLogon -le [DateTime]::FromFileTime($UserLastlogon.LastLogon)) 
	        { 
	            $RealUserLastLogon = [DateTime]::FromFileTime($UserLastlogon.LastLogon) 
	        } 
	    } 
	}
	
	Write-Output "$samaccountname; $UserEnabled; $UserEmployeeID; $UserDisplayName; $RealUserLastLogon"
	$RealUserLastLogon = $null
}