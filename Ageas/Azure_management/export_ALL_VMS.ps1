
Get-AzureVM | select name, servicename | ForEach-Object {
	
	$vm = Get-AzureVM  -ServiceName CSIIS01 -Name SPAZIIS01
	$vmOSDisk = $vm | Get-AzureOSDisk
	$vmDataDisks = $vm | Get-AzureDataDisk
	
	$exportFolder = "d:\"
	
	if (!(Test-Path -Path $exportFolder))
	{
		
		New-Item -Path $exportFolder -ItemType Directory
		
	}
	
	$exportPath = $exportFolder + "\" + $vm.Name + ".xml"
	
	$vm | Export-AzureVM -Path $exportPath
}



