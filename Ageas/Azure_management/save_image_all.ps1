

 Get-AzureVM | select name, servicename | ForEach-Object {
       
      

       Save-AzureVMImage   -ImageName $_.Name  -Name $_.Name  -ServiceName $_.Servicename  -ImageLabel $_.Name -OSState Specialized

}


