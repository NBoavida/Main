
<#     
       .NOTES
       ===========================================================================
       Created on:        30/09/2014 
       Created by:        Frederico Frazão
       Organization:     Agap2
        Filename: CreateILBSQL 
       
       ===========================================================================
       .DESCRIPTION
Criação e configuração de Azure Internal Load Balancer for AGEASNET SQLCluster
#>





$svc = "HANETSQL01"
$ilb = "AGHASQL01"
Add-AzureInternalLoadBalancer -ServiceName $svc -InternalLoadBalancerName $ilb -SubnetName Data -StaticVNetIPAddress 10.108.66.9

$prot = "tcp"
$locport = 1433
$pubport = 1433
$epname = "DBTIER1"
$vmname = "SPAZSQL01"
Get-AzureVM –ServiceName $svc –Name $vmname | Add-AzureEndpoint -Name $epname -LBSetName $ilb -Protocol $prot  -LocalPort $locport -PublicPort $pubport –DefaultProbe -InternalLoadBalancerName $ilb | Update-AzureVM

$epname2 = "DBTIER2"
$vmname2 = "SPAZSQL02"
Get-AzureVM –ServiceName $svc –Name $vmname2 | Add-AzureEndpoint -Name $epname2  -LBSetName $ilb -Protocol $prot -LocalPort $locport -PublicPort $pubport –DefaultProbe -InternalLoadBalancerName $ilb | Update-AzureVM

Get-AzureService -ServiceName hanetsql01 | Get-AzureInternalLoadBalancer