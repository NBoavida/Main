 
cls 
#get a list of domain controllers in domain (replace Contoso with your domain)
$DCs=(GET-ADDOMAIN -Identity fidelidademundial.com).ReplicadirectoryServers

#loop through list of DCs and dump lines with "scavenging" in them 
foreach ($dc in $DCs) 
{ 
    $output = dnscmd $DC /info 
    #Write-host $output |fl 
    $string =$output |Select-string "Scavenging" 
    Write-host $DC 
    Write-host $string 
    Write-host "" 
        
} 
#-----------------END SCRIPT CODE------------------