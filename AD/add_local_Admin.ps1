
 $cname = 'FMNRAHR07W7157'
$user = 'F071396'

$validate= Get-ADComputer -Identity $cname -Properties employeeNumber |select employeeNumber

if($validate) {            
    
     Set-ADComputer -Identity $cname -replace @{employeeNumber=$user}        
} else {            
     
     Set-ADComputer -Identity $cname -add @{employeeNumber=$user}          
}
  
  $validate