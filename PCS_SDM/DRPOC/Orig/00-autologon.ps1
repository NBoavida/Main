
$registryPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"

$Name = "AutoAdminLogon"

$value = "1"
New-ItemProperty -Path $registryPath -Name $name -Value $value   -PropertyType DWORD -Force | Out-Null





$registryPath1 = "HKLM:\SYSTEM\ControlSet002\Services\TarefasDistribuicao"

$Name1 = "Start"

$value1 = "4" 

<#
Valores de Start dos serviços
  Automatic   2
  Manual      3
 Disabled    4
#>


New-ItemProperty -Path $registryPath1 -Name $name1 -Value $value1   -PropertyType DWORD -Force | Out-Null



