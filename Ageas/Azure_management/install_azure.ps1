<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2014 v4.1.66
	 Created on:   	26/09/2014 22:06
	 Created by:   	user01
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
Write-Host "Donwload file "
Get-AzurePublishSettingsFile
$user = [Environment]::UserName

$user

cmd /c pause
Write-Host "get file"
$file = Get-Item  C:\Users\$user\Downloads\*.publishsettings
cmd /c pause
Write-Host "Importing file"
Import-AzurePublishSettingsFile C:\Users\$user\Downloads\*.publishsettings

cmd /c pause
Write-Host "validation"
Get-AzureSubscription

Write-Host "finish"