<#
- Maps Source Safe Drives
    172.16.120.128
- Maps DOIT Share Drive
- SQL BACKUP To Local Drive
- SS backups to Local Drives
- Copy SQL + SS to Share
- Backup Deploy
         -----------
        .
        NOTES
#>

#Network Path Settings:

$nm34 = "\\10.90.151.34";     # SQL Server Bcpcorp.dev I
$sqlbk34 = "\\10.90.151.34\e$";     # SQL Server Backup Dir Bcpcorp.dev I
$nm35 = "\\10.90.151.35";     # SQL Server Bcpcorp.dev II
$nmSql1 = "\\(local)";     # SQL Server PT Cloud
$nmSql2 = "\\(local)";     # SQL Server PT Cloud
$nmdoit = "\\(local)";     # Share Doit
$DOITSQL  = "\\(local)";     # Share Doit
$DOITSS  = "\\(local)";     # Share Doit
$nmss = "\\(local)";     # Share Source SAfe PT Cloud

# Credentials:
$password = "01000000d08c9ddf0115d1118c7a00c04fc297eb010000006051e8f1c3c1bf499c9c4de284f781c60000000002000000000003660000c0000000100000004192baf69aef46c06616daa1647100a70000000004800000a00000001000000057c6e7400937cb124c9d932e3973cfb11800000029ba91d7b6ce0ea3f70b252e538d83f0916ed2488441092c14000000abd30f0eeedb1dedd5d727149a20a85945ada4a6"
$passwordSecure = ConvertTo-SecureString -String $password
$cred = New-Object system.Management.Automation.PSCredential("BCPCORP.DEV\D333867", $passwordSecure)
$cred

###### Map Network Drives#######
<#SQL Server Bcpcorp.dev I #>
$objNet = New-Object -ComObject WScript.Network
$objNet.MapNetworkDrive("Z:", "$nm34\e$" )
<#SQL Server Bcpcorp.dev II #>
$objNet = New-Object -ComObject WScript.Network
$objNet.MapNetworkDrive("U:", "$nm35\e$" )
<#SQL Server PT Cloud I #>
$objNet = New-Object -ComObject WScript.Network
$objNet.MapNetworkDrive("Y:", "$nmSql1\e$" )
<#SQL Server PT Cloud II #>
$objNet = New-Object -ComObject WScript.Network
$objNet.MapNetworkDrive("W:", "$nmSql2\d$" )
<#SQL Server PT DOit  #>
$objNet = New-Object -ComObject WScript.Network
$objNet.MapNetworkDrive("P:", "$nmdoit\d$" )
<#SQL Source Safe PT Cloud I #>
$objNet = New-Object -ComObject WScript.Network
$objNet.MapNetworkDrive("W:", "$nmSql2\d$" )

#Start Backuping... 
<#SQL#>
copy-item $sqlbk34 -destination $DOITSQL -recurse
copy-item $sqlbk35 -destination $DOITSQL -recurse
copy-item $sqlcl1 -destination $DOITSQL -recurse
copy-item $sqlcl2 -destination $DOITSQL -recurse
<#SS#>
copy-item $nmss -destination $DOITSS -recurse