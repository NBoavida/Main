$cn= $env:COMPUTERNAME 
$cnbeg= 'SPF0000'
$cnfim= $cn.Substring(7)
$novocn = "$cnbeg$cnfim"


# Set new CN

Rename-Computer -ComputerName $env:COMPUTERNAME  -NewName $novocn




 Restart-Computer -ComputerName $env:COMPUTERNAME -confirm:$false

