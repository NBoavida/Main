Import-Module activedirectory
$ErrorActionPreference="continue"
$a=Get-ChildItem "\\fidelidademundial.com\users\AIN-MC"
foreach ($b in $a) 
    { 
        Get-ADUser $b.name -Properties homedirectory | FT name,homedirectory -Wrap -AutoSize -HideTableHeaders >>"D:\listagemHomeFolders.txt"
    } 