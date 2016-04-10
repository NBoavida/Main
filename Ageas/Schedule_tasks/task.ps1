
mkdir C:\Packages\Plugins\ageasdev\

Copy-Item \\sdazfs01\WITNESS\on.ps1 C:\Packages\Plugins\ageasdev\on.ps1 -Force
Copy-Item \\sdazfs01\WITNESS\off.ps1 C:\Packages\Plugins\ageasdev\off.ps1 -Force

Copy-Item \\sdazfs01\WITNESS\on.xml C:\Packages\Plugins\ageasdev\on.xml -Force
Copy-Item \\sdazfs01\WITNESS\off.xml C:\Packages\Plugins\ageasdev\off.xml -Force

Start-Sleep -Seconds 3
$xmk= get-conten  C:\Packages\Plugins\ageasdev\on.xml | out-string

Register-ScheduledTask -Xml $xmk  -TaskName "in" -User ageasdev\x333867 -Password !!!!!!!!!!!!!!!!!9 –Force

$xmo= get-content C:\Packages\Plugins\ageasdev\on.xml | out-string

Register-ScheduledTask -Xml $xmo  -TaskName "out" -User ageasdev\x333867 -Password !!!!!!!!!!!!!!!!!9 –Force