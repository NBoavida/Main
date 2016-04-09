<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2014 v4.1.66
	 Created on:   	19/10/2014 12:53
	 Created by:   	user01
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
Get-AzureVM -ServiceName "spazop01" -Name "spazop01" | Get-AzureVMMicrosoftAntimalwareExtension

