
 Get-AzureVM  | select name, servicename | ForEach-Object {
	
	get-azurevm  -ServiceName $_.Servicename -Name $_.Name | Select DeploymentName, Name, HostName, DNSName, ServiceName, AvailabilitySetName, IpAddress, PowerState | Out-File d:\Status1.txt -Append
	
	
}




