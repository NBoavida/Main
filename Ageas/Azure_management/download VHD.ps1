#http://michaelwasham.com/windows-azure-powershell-reference-guide/uploading-and-downloading-vhds-to-windows-azure/

 
$sourceVHD = "https://portalvhdsjhkyqvhd88p4l.blob.core.windows.net/vhds/tjsprpka.ukj201407191748130140.vhd"
$destinationVHD = "e:\azure\wdazvs02.vhd"
 
Save-AzureVhd -Source $sourceVHD -LocalFilePath $destinationVHD `
             -NumberOfThreads 5