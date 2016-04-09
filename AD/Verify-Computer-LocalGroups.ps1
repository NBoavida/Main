
$ChildGroups = "Domain Admins", "LADM-S3EC", "V002113"
$LocalAdminGroup = "Administrators"
$LocalRDPGroup = "Remote Desktop Users"

$MemberAdminNames = @()
$MemberRDPNames = @()
# uncomment this line to grab list of computers from a file
# $Servers = Get-Content serverlist.txt
#$Servers = $env:computername # for testing on local computer
$Servers = "FMNRJML02W3020" # for testing on a computer
foreach ( $Server in $Servers ) {
	$GroupAdmin= [ADSI]"WinNT://$Server/$LocalAdminGroup,group"
	$MembersAdmin = @($GroupAdmin.psbase.Invoke("Members"))
	$MembersAdmin | ForEach-Object {
		$MemberAdminNames += $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null) + " "
	} 
	
	$GroupRDP= [ADSI]"WinNT://$Server/$LocalRDPGroup,group"
	$MembersRDP = @($GroupRDP.psbase.Invoke("Members"))
	$MembersRDP | ForEach-Object {
		$MemberRDPNames += $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null) + " "
	} 
	
	$ChildGroups | ForEach-Object {
		$output = "" | Select-Object Server, Group, InLocalAdmin, InLocalRDP
		$output.Server = $Server
		$output.Group = $_
		$output.InLocalAdmin = $MemberAdminNames -Contains $_
		$output.InLocalRDP = $MemberRDPNames -Contains $_
		Write-Output $output
	}
}
