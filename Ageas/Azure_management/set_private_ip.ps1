

#get-azurevm -Servicename ageas-dev-dc -name ageasdevdc1 | Set-AzureStaticVNetIP -IPAddress "10.0.0.4"  | Update-AzureVM   | Out-File c:\azure\AgeasDevDC1.txt
get-azurevm -Servicename 	AGEAS-NET-DC  	-Name	AGEASNETDC1 | Set-AzureStaticVNetIP -IPAddress "10.108.79.196"  | Update-AzureVM   | Out-File c:\azure\AGEASNETDC1.txt
get-azurevm -Servicename 	AGEAS-NET-DC  	-Name	ageasnetdc2 | Set-AzureStaticVNetIP -IPAddress "10.108.79.197"  | Update-AzureVM   | Out-File c:\azure\ageasnetdc2.txt
get-azurevm -Servicename 	HANETSQL01	-Name	SPAZSQL01 | Set-AzureStaticVNetIP -IPAddress "10.108.66.4"  | Update-AzureVM   | Out-File c:\azure\SPAZSQL01.txt
get-azurevm -Servicename 	HANETSQL01	-Name	SPAZSQL02 | Set-AzureStaticVNetIP -IPAddress "10.108.66.5"  | Update-AzureVM   | Out-File c:\azure\SPAZSQL02.txt
get-azurevm -Servicename 	HANETSQL01	-Name	SPHADATA01 | Set-AzureStaticVNetIP -IPAddress "10.108.66.7"  | Update-AzureVM   | Out-File c:\azure\SPHADATA01.txt
get-azurevm -Servicename 	SDAZIIS01	-Name	SDAZIIS01 | Set-AzureStaticVNetIP -IPAddress "10.108.80.4"  | Update-AzureVM   | Out-File c:\azure\SDAZIIS01.txt
get-azurevm -Servicename 	sdazop01	-Name	sdazop01 | Set-AzureStaticVNetIP -IPAddress "10.108.95.228"  | Update-AzureVM   | Out-File c:\azure\sdazop01.txt
get-azurevm -Servicename 	SDAZSP13-01  	-Name	SDAZSP13-01 | Set-AzureStaticVNetIP -IPAddress "10.108.80.5"  | Update-AzureVM   | Out-File c:\azure\SDAZSP13-01.txt
get-azurevm -Servicename 	SDAZSQL01	-Name	SDAZSQL01 | Set-AzureStaticVNetIP -IPAddress "10.108.82.4"  | Update-AzureVM   | Out-File c:\azure\SDAZSQL01.txt
get-azurevm -Servicename 	sdaztfs01	-Name	sdaztfs01 | Set-AzureStaticVNetIP -IPAddress "10.108.83.4"  | Update-AzureVM   | Out-File c:\azure\sdaztfs01.txt
get-azurevm -Servicename 	spazop01	-Name	spazop01 | Set-AzureStaticVNetIP -IPAddress "10.108.79.228"  | Update-AzureVM   | Out-File c:\azure\spazop01.txt
get-azurevm -Servicename 	   spazsp2013-01      	-Name	   spazsp2013-01 | Set-AzureStaticVNetIP -IPAddress "10.108.64.4"  | Update-AzureVM   | Out-File c:\azure\spazsp2013-01.txt
get-azurevm -Servicename 	SPAZSP2013-02    	-Name	SPAZSP2013-02 | Set-AzureStaticVNetIP -IPAddress "10.108.64.5"  | Update-AzureVM   | Out-File c:\azure\SPAZSP2013-02.txt
get-azurevm -Servicename 	sqazsp13-01	-Name	sqazsp13-01 | Set-AzureStaticVNetIP -IPAddress "10.108.64.4"  | Update-AzureVM   | Out-File c:\azure\sqazsp13-01.txt

#get-azurevm -Servicename 	  wdazsp2013-01 	-Name	  wdazsp2013-01 | Set-AzureStaticVNetIP -IPAddress "10.108.83.5"  | Update-AzureVM   | Out-File c:\azure\wdazsp2013-01.txt
#get-azurevm -Servicename 	wdazvs01	-Name	wdazvs01 | Set-AzureStaticVNetIP -IPAddress "10.108.83.7"  | Update-AzureVM   | Out-File c:\azure\wdazvs01.txt
#get-azurevm -Servicename 	wdazvs02	-Name	wdazvs02 | Set-AzureStaticVNetIP -IPAddress "10.108.83.6"  | Update-AzureVM   | Out-File c:\azure\wdazvs02.txt

