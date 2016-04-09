
workflow Connect-Azure
{
    Param
    (   
        [Parameter(Mandatory=$true)]
        [String]
        $AzureConnectionName       
    )

	
    # Get the Azure connection asset that is stored in the Auotmation service based on the name that was passed into the runbook 
    $AzureConn = Get-AutomationConnection -Name $AzureConnectionName
    if ($AzureConn -eq $null)
    {
        throw "Could not retrieve '$AzureConnectionName' connection asset. Check that you created this first in the Automation service."
    }

    # Get the Azure management certificate that is used to connect to this subscription
    $Certificate = Get-AutomationCertificate -Name $AzureConn.AutomationCertificateName
    if ($Certificate -eq $null)
    {
        throw "Could not retrieve '$AzureConn.AutomationCertificateName' certificate asset. Check that you created this first in the Automation service."
    }

    # Set the Azure subscription configuration
    Set-AzureSubscription -SubscriptionName $AzureConnectionName -SubscriptionId $AzureConn.SubscriptionID -Certificate $Certificate
}