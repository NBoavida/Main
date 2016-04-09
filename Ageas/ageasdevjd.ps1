###
#
#  Post Creation
#
##

$domain = "Ageasdev.com"
$password = "muksmuqqwqqqqks9" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\x333867" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential

Start-Sleep -Seconds 3

$time = "{0:yyyy-MM-dd HH:mm:ss}" -f (get-date)
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Data Source=10.108.82.4\inst02;;Initial Catalog=ageasdev;user id=ageasAudit;Pwd=audit" 
$conn.open()
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.connection = $conn
$cmd.commandtext = "INSERT INTO JoinDomain (hostname,xnuc,action,date) VALUES('$env:COMPUTERNAME','$env:USERNAME', 'JoinDomain', '$time' )"
$cmd.executenonquery()
$conn.close()



 