<#     
       .NOTES
       ===========================================================================
       Created by:        Frederico Frazão
       Organization:     Agap2
        ACL SQL HA
       ===========================================================================
       .DESCRIPTION
    ACL SQLHA 

#>

$aclsql = New-AzureAclConfig

Set-AzureAclConfig –AddRule –ACL $aclsql –Order 100 –Action permit –RemoteSubnet “10.108.64.0/20” –Description “SQL HA ACL”

Get-AzureVM –ServiceName haspazsql –Name spazsql01 | set-AzureEndpoint –Name “SQLEP” –Protocol tcp –Localport 50000 - PublicPort 50000 –ACL $aclsql |Update-AzureVM 
Get-AzureVM –ServiceName haspazsql –Name spazsql02 | set-AzureEndpoint –Name “SQLEP” –Protocol tcp –Localport 50000 - PublicPort 50000 –ACL $aclsql |Update-AzureVM 

