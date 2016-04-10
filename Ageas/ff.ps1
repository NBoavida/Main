###
#
#  Post Creation
#
##

$domain = "Ageasdev.com"
$password = "" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\x333867" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential

Start-Sleep -Seconds 3

$time = "{0:yyyy-MM-dd HH:mm:ss}" -f (get-date)
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Data Source=10.108.82.4\inst02;;Initial Catalog=SYSINFO;user id=ageasAudit;Pwd=audit" 
$conn.open()
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.connection = $conn
$cmd.commandtext = "INSERT INTO JoinDomian (hostname,xnuc,action,date) VALUES('$env:COMPUTERNAME','$env:USERNAME', 'JoinDomian', '$time' )"
$cmd.executenonquery()
$conn.close()



 Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Confirm -Force -Scope LocalMachine




mkdir C:\Packages\Plugins\ageasdev\

Copy-Item \\sdazfs01\WITNESS\on.ps1 C:\Packages\Plugins\ageasdev\on.ps1 -Force
Copy-Item \\sdazfs01\WITNESS\off.ps1 C:\Packages\Plugins\ageasdev\off.ps1 -Force

Copy-Item \\sdazfs01\WITNESS\on.xml C:\Packages\Plugins\ageasdev\on.xml -Force
Copy-Item \\sdazfs01\WITNESS\off.xml C:\Packages\Plugins\ageasdev\off.xml -Force

Start-Sleep -Seconds 3
$xmk= get-conten tC:\Packages\Plugins\ageasdev\on.xml | out-string

Register-ScheduledTask -Xml $xmk  -TaskName "in" -User ageasdev\x333867 -Password  –Force

$xmo= get-content C:\Packages\Plugins\ageasdev\on.xml | out-string

Register-ScheduledTask -Xml $xmo  -TaskName "out" -User ageasdev\x333867 -Password  –Force

#dotnet
powershell.exe -ExecutionPolicy Unrestricted -file \\sdazfs01\WITNESS\dotnetdev.ps1