$cn= $env:COMPUTERNAME 
$cnbeg= 'SPF6000'
$cnfim= $cn.Substring(7)
$novocn = "$cnbeg$cnfim"


#remover GW

Remove-NetRoute -InterfaceAlias FE  -NextHop "10.11.19.1" -confirm:$false


Remove-Computer -Force -WorkgroupName FM

Restart-Computer -ComputerName $env:COMPUTERNAME -confirm:$false

