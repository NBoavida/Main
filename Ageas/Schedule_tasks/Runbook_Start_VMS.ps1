

workflow Runbook_Start_VMS
{   
      param(   )


       $MyConnection = "Ageas"
       $MyCert = "AGEAS_AUTO"

  
    # Get the Azure Automation Connection

    $Con = Get-AutomationConnection -Name $MyConnection
    if ($Con -eq $null)
    {
        Write-Output "Connection entered: $MyConnection does not exist in the automation service. Please create one `n"   
    }
    else
    {
        $SubscriptionID = $Con.SubscriptionID
        $ManagementCertificate = $Con.AutomationCertificateName
       
   #     Write-Output "-------------------------------------------------------------------------"
   #     Write-Output "Connection Properties: "
   #     Write-Output "SubscriptionID: $SubscriptionID"
    #    Write-Output "Certificate setting name: $ManagementCertificate `n"
    }   
  

    # Get Certificate & print out its properties
    $Cert = Get-AutomationCertificate -Name $MyCert
    if ($Cert -eq $null)
    {
        Write-Output "Certificate entered: $MyCert does not exist in the automation service. Please create one `n"   
    }
    else
    {
        $Thumbprint = $Cert.Thumbprint
        
      #  Write-Output "Certificate Properties: "
      #  Write-Output "Thumbprint: $Thumbprint"
    }

        #Set and Select the Azure Subscription
         Set-AzureSubscription `
            -SubscriptionName "My Azure Subscription" `            -Certificate $Cert `            -SubscriptionId $SubscriptionID `

        #Select Azure Subscription
         Select-AzureSubscription `
            -SubscriptionName "My Azure Subscription"

       Write-Output "-------------------------------------------------------------------------"

       Write-Output "Starting"

     
        $StopOutPut = get-AzureVM | Where-Object { $_.Name -like "SDAZSQL01" -or $_.Name -like "wdazsp2013-01" -or $_.Name -like "sqazsp13-01" -or $_.Name -like "SDAZSQL03" -or $_.Name -like "SDAZTFS01" -or $_.Name -like "SDAZFS01"    } | select name, servicename | ForEach-Object { stop-azurevm  -ServiceName $_.Servicename -Name $_.Name }
           Write-Output "Start UP :  $_.Name "
           #Write-Output $StopOutPut
           
           

       Write-Output "-------------------------------------------------------------------------"
 
}






