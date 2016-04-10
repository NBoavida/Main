

#add to Domian


$domain = "fidelidademundial.com" 
$fmpass = "!!!!!!!!!!!!!!!!!" | ConvertTo-SecureString -asPlainText -Force 
$fmuser = "fm\yps0079" 
$fmcred = New-Object System.Management.Automation.PSCredential ( $fmuser, $fmpass )
Add-Computer -DomainName $domain -Credential $fmcred   
Restart-Computer -ComputerName $env:COMPUTERNAME -confirm:$false