<#     
       .NOTES
       ===========================================================================
       Created by:        Frederico Frazão
       Organization:     Agap2
        PIP Ageas
       ===========================================================================
       .DESCRIPTION
Definir PIP para baracuda e Cluster SQL 

#>

Get-AzureVM -ServiceName ageasfw  -Name spazfw01 | Set-AzurePublicIP -PublicIPName FWNETIP | Update-AzureVM

Get-AzureVM -ServiceName haspazsql  -Name spazsql01 | Set-AzurePublicIP -PublicIPName HASQLNETIP | Update-AzureVM