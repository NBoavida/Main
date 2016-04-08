


# Add YAS0260 to Localgroups

$accountToAdd = 'fm\YAS0260' 

net localgroup "ConfigMgr Remote Control Users" $accountToAdd /add
net localgroup "Distributed COM Users" $accountToAdd /add
net localgroup  "Event Log Readers" $accountToAdd /add
net localgroup "Performance Monitor Users" $accountToAdd /add
net localgroup  "Remote Management Users" $accountToAdd /add
net localgroup "Users" $accountToAdd /add 



# Log on Localy to YAS0260

$sidstr = $null
try {
	$ntprincipal = new-object System.Security.Principal.NTAccount "$accountToAdd"
	$sid = $ntprincipal.Translate([System.Security.Principal.SecurityIdentifier])
	$sidstr = $sid.Value.ToString()
} catch {
	$sidstr = $null
}

Write-Host "Account: $($accountToAdd)" -ForegroundColor DarkCyan

if( [string]::IsNullOrEmpty($sidstr) ) {
	Write-Host "Account not found!" -ForegroundColor Red
	exit -1
}

Write-Host "Account SID: $($sidstr)" -ForegroundColor DarkCyan

$tmp = [System.IO.Path]::GetTempFileName()

Write-Host "Export current Local Security Policy" -ForegroundColor DarkCyan
secedit.exe /export /cfg "$($tmp)" 

$c = Get-Content -Path $tmp 

$currentSetting = ""

foreach($s in $c) {
	if( $s -like "SeInteractiveLogonRight*") {
		$x = $s.split("=",[System.StringSplitOptions]::RemoveEmptyEntries)
		$currentSetting = $x[1].Trim()
	}
}

if( $currentSetting -notlike "*$($sidstr)*" ) {
	Write-Host "Modify Setting ""Allow Logon Locally""" -ForegroundColor DarkCyan
	
	if( [string]::IsNullOrEmpty($currentSetting) ) {
		$currentSetting = "*$($sidstr)"
	} else {
		$currentSetting = "*$($sidstr),$($currentSetting)"
	}
	
	Write-Host "$currentSetting"
	
	$outfile = @"
[Unicode]
Unicode=yes
[Version]
signature="`$CHICAGO`$"
Revision=1
[Privilege Rights]
SeInteractiveLogonRight = $($currentSetting)
"@

	$tmp2 = [System.IO.Path]::GetTempFileName()
	
	
	Write-Host "Import new settings to Local Security Policy" -ForegroundColor DarkCyan
	$outfile | Set-Content -Path $tmp2 -Encoding Unicode -Force

	#notepad.exe $tmp2
	Push-Location (Split-Path $tmp2)
	
	try {
		secedit.exe /configure /db "secedit.sdb" /cfg "$($tmp2)" /areas USER_RIGHTS 
		#write-host "secedit.exe /configure /db ""secedit.sdb"" /cfg ""$($tmp2)"" /areas USER_RIGHTS "
	} finally {	
		Pop-Location
	}
} else {
	Write-Host "NO ACTIONS REQUIRED! Account already in ""Allow Logon Locally""" -ForegroundColor DarkCyan
}

Write-Host "Done." -ForegroundColor DarkCyan



#Grant Registry Permissions 

$acl = Get-Acl HKLM:\Software\Microsoft\Microsoft SQL Server
$rule = New-Object System.Security.AccessControl.RegistryAccessRule ($accountToAdd,"FullControl","Allow")
$acl.SetAccessRule($rule)
$acl |Set-Acl -Path HKLM:\Software\Microsoft\Microsoft SQL Server
#endrgion

#Grant WMI Namespaces

#root
.\Set-WmiNamespaceSecurity.ps1 root add $accountToAdd Enable
.\Set-WmiNamespaceSecurity.ps1 root add $accountToAdd RemoteAccess 
.\Set-WmiNamespaceSecurity.ps1 root add $accountToAdd MethodExecute
.\Set-WmiNamespaceSecurity.ps1 root add $accountToAdd ReadSecurity
.\Set-WmiNamespaceSecurity.ps1 root add $accountToAdd Writesecurity

#root\cimv2
.\Set-WmiNamespaceSecurity.ps1 root\cimv2 add $accountToAdd Enable
.\Set-WmiNamespaceSecurity.ps1 root\cimv2 add $accountToAdd RemoteAccess 
.\Set-WmiNamespaceSecurity.ps1 root\cimv2 add $accountToAdd MethodExecute
.\Set-WmiNamespaceSecurity.ps1 root\cimv2 add $accountToAdd ReadSecurity
.\Set-WmiNamespaceSecurity.ps1 root\cimv2 add $accountToAdd Writesecurity

#root\default

.\Set-WmiNamespaceSecurity.ps1 root\default add $accountToAdd Enable
.\Set-WmiNamespaceSecurity.ps1 root\default add $accountToAdd RemoteAccess 
.\Set-WmiNamespaceSecurity.ps1 root\default add $accountToAdd MethodExecute
.\Set-WmiNamespaceSecurity.ps1 root\default add $accountToAdd ReadSecurity
.\Set-WmiNamespaceSecurity.ps1 root\default add $accountToAdd Writesecurity

#root\Microsoft\Sqlserver

.\Set-WmiNamespaceSecurity.ps1 root\Microsoft\Sqlserver add $accountToAdd Enable
.\Set-WmiNamespaceSecurity.ps1 root\Microsoft\Sqlserver add $accountToAdd RemoteAccess 
.\Set-WmiNamespaceSecurity.ps1 root\Microsoft\Sqlserver add $accountToAdd MethodExecute
.\Set-WmiNamespaceSecurity.ps1 root\Microsoft\Sqlserver add $accountToAdd ReadSecurity
.\Set-WmiNamespaceSecurity.ps1 root\Microsoft\Sqlserver add $accountToAdd Writesecurity



