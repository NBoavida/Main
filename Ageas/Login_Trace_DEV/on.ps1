
$time = Get-Date -format G
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Data Source=10.108.82.6\inst02;;Initial Catalog=Ageasdev;user id=ageasAudit;Pwd=audit" 
$conn.open()
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.connection = $conn
$cmd.commandtext = "INSERT INTO Logins (hostname,xnuc,action,date) VALUES('$env:COMPUTERNAME','$env:USERNAME', 'login', '$time' )"
$cmd.executenonquery()
$conn.close()

