###
#
#  Post Creation script 
#
##


$domain = "Ageasdev.com"
$password = "!!!!!!!!!!!!!!!!!9" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\x333867" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential




$time = Get-Date -format G
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Data Source=Sdazsql02\inst02;Initial Catalog=SYSINFO;;user id=ageasAudit;Pwd=audit" 
$conn.open()
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.connection = $conn
$cmd.commandtext = "INSERT INTO JoinDomain (hostname,xnuc,action,date) VALUES('$env:COMPUTERNAME','$env:USERNAME', 'Joindomian', '$time' )"
$cmd.executenonquery()
$conn.close()


#shutdown.exe -r 
