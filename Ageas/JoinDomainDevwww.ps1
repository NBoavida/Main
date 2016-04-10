###
#
#  Post Creation
#
##

$domain = "Ageasdev.com"
$password = "!!!!!!!!!!!!!!!!!9" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\x333867" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential

Install-WindowsFeature Net-Framework-Core -source \\sdazfs01\sxs




