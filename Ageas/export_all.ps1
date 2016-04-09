<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2014 v4.1.66
	 Created on:   	28/09/2014 23:07
	 Created by:   	user01
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
Export-AzureVM -ServiceName	ageas-dev-dc	-Name	AGEASdevDC1	-Path	"c:\azure\AGEASDEVDC1.xml"
Export-AzureVM -ServiceName	AGEAS-NET-DC  	-Name	AGEASNETDC1	-Path	"c:\azure\AGEASNETDC1.xml"
Export-AzureVM -ServiceName	AGEAS-NET-DC  	-Name	ageasnetdc2	-Path	"c:\azure\ageasnetdc2.xml"
Export-AzureVM -ServiceName	HANETSQL01	-Name	SPAZSQL01	-Path	"c:\azure\SPAZSQL01.xml"
Export-AzureVM -ServiceName	HANETSQL01	-Name	SPAZSQL02	-Path	"c:\azure\SPAZSQL02.xml"
Export-AzureVM -ServiceName	HANETSQL01	-Name	SPHADATA01	-Path	"c:\azure\SPHADATA01.xml"
Export-AzureVM -ServiceName	SDAZIIS01	-Name	SDAZIIS01	-Path	"c:\azure\SDAZIIS01.xml"
Export-AzureVM -ServiceName	sdazop01	-Name	sdazop01	-Path	"c:\azure\sdazop01.xml"
Export-AzureVM -ServiceName	SDAZSP13-01  	-Name	SDAZSP13-01  	-Path	"c:\azure\SDAZSP13-01.xml"
Export-AzureVM -ServiceName	SDAZSQL01	-Name	SDAZSQL01	-Path	"c:\azure\SDAZSQL01.xml"
Export-AzureVM -ServiceName	sdaztfs01	-Name	sdaztfs01	-Path	"c:\azure\sdaztfs01.xml"
Export-AzureVM -ServiceName	spazop01	-Name	spazop01	-Path	"c:\azure\spazop01.xml"
Export-AzureVM -ServiceName	   spazsp2013-01      	-Name	   spazsp2013-01      	-Path	"c:\azure\spazsp2013-01.xml"
Export-AzureVM -ServiceName	SPAZSP2013-02    	-Name	SPAZSP2013-02    	-Path	"c:\azure\SPAZSP2013-02.xml"
Export-AzureVM -ServiceName	sqazsp13-01	-Name	sqazsp13-01	-Path	"c:\azure\sqazsp13-01.xml"
Export-AzureVM -ServiceName	  wdazsp2013-01 	-Name	  wdazsp2013-01 	-Path	"c:\azure\wdazsp2013-01.xml"
Export-AzureVM -ServiceName	wdazvs01	-Name	wdazvs01	-Path	"c:\azure\wdazvs01.xml"
