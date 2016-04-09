$adminCredentials = Get-Credential -Message "Enter new Admin credentials"



$VM = Get-AzureVM -Name wdazsp2013-02 -ServiceName ageasdev
    If ($VM.VM.ProvisionGuestAgent) {
        Set-AzureVMAccessExtension -VM $VM `
            -UserName $adminCredentials.UserName `
            -Password $adminCredentials.GetNetworkCredential().Password `
            -ReferenceName "VMAccessAgent" | 
        Update-AzureVM
        Restart-AzureVM -ServiceName $VM.ServiceName -Name $VM.Name

        }

        #adminazdoit
        #ageasaz2014!