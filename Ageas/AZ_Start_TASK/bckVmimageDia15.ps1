    <#
    ======================================================================================================================================================
    ======================================================================================================================================================
    ======================================================================================================================================================

    ATENÇÃO PARA REMOVER UMA DAS MAQUINAS DO PROCESSO TEM DE SE REMOVER A LINHA, CASO SEJA COMENTADO O SCRIPT NÃO EXECUTA ATÉ AO FINAL 
    
                -de AgeasDev, o Servidor SDAZSQL03 e SDAZOP02 não estão conteplados. 

    ======================================================================================================================================================
    ======================================================================================================================================================
    ======================================================================================================================================================
                                                    
.NOTES
	===========================================================================
	 Created on:   	16/04/2015 22:06
	 Created by:   	Frederico Frazão
	 Organization: 	Agap2  	
	===========================================================================
	.DESCRIPTION
		Save backupImage Dev cada dia 15 de cada mês 
            -de AgeasDev, o Servidor SDAZSQL03 e SDAZOP02 não estão conteplados. 


#>


#     
 Get-AzureVM  | Where-Object { `
                       $_.Name -like "wdazsp2013-01" `
         -or $_.Name -like "SDAZFS01"`
         -or $_.Name -like "SDAZIIS01" `
         -or $_.Name -like "wdazvs03" `
         -or $_.Name -like "sqazsp13-01" `
         -or $_.Name -like "wdazvs02" `
         -or $_.Name -like "wdazvs01"  `
         -or $_.Name -like "WDVS2015"  `
         -or $_.Name -like "wdazsp2013-02"  `
	     -or $_.Name -like "wdazsp2013-03"  `
	     -or $_.Name -like "wdazsp2013-04"  `
         -or $_.Name -like "wdazumbraco-01" `
         -or $_.Name -like "SDAZAPP01"  `
         -or $_.Name -like "SDAZAPP02"  `
         -or $_.Name -like "SRAZFS01"  `
         -or $_.Name -like "SRAZSP2013-01"  `
         -or $_.Name -like "SRAZSQL01"  `
         -or $_.Name -like "SDAZSP13-01"  `
        -or $_.Name -like "SDAZTFS01"  `
                    
           } | select name, servicename, InstanceName | ForEach-Object {

          start-azurevm  -ServiceName $_.Servicename -Name $_.Name -ErrorAction SilentlyContinue

          while(Get-AzureVM -ServiceName $_.Servicename  -Name $_.Name | Where-Object { $_.Status -ne "ReadyRole"} )
{
  echo "A Arrancar a Vm $label , A Processar pedido, Aguarde"
}
       
stop-azurevm  -ServiceName $_.Servicename -Name $_.Name  -StayProvisioned


$dia = '_15'


$label = $_.InstanceName+$dia

Remove-AzureVMImage –ImageName $label –DeleteVHD;


while(Get-AzureVM -ServiceName $_.Servicename  -Name $_.Name | Where-Object { $_.Status -ne "StoppedVM"} )
{
  echo "A parar a Vm $label , A Processar pedido, Aguarde"
}

Save-AzureVMImage   -ImageName $label  -Name $_.Name -ServiceName $_.Servicename  -ImageLabel $_.Name -OSState Specialized

$time = Get-Date -format G
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Data Source=10.108.82.6\inst02;;Initial Catalog=Ageasdev;user id=ageasAudit;Pwd=audit" 
$conn.open()
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.connection = $conn
$cmd.commandtext = "INSERT INTO Vmimages (vm,type,action,date) VALUES('$label','Specialized', 'BackupImage', '$time' )"
$cmd.executenonquery()
$conn.close()

}


#region Stop \ backup \ start 

          Get-AzureVM  | Where-Object { `
              $_.Name -like "SDAZTS01" `         -or $_.Name -like "sdazop01" `
         -or $_.Name -like "SDAZSQL02" `
         -or $_.Name -like "AgeasDevDC1" `    
  } | select name, servicename, InstanceName | ForEach-Object {
       
 start-azurevm  -ServiceName $_.Servicename -Name $_.Name -ErrorAction SilentlyContinue

          while(Get-AzureVM -ServiceName $_.Servicename  -Name $_.Name | Where-Object { $_.Status -ne "ReadyRole"} )
{
  echo "A Arrancar a Vm $label , A Processar pedido, Aguarde"
}
       
stop-azurevm  -ServiceName $_.Servicename -Name $_.Name  -StayProvisioned

Remove-AzureVMImage –ImageName $label –DeleteVHD;

while(Get-AzureVM -ServiceName $_.Servicename  -Name $_.Name | Where-Object { $_.Status -ne "StoppedVM"} )
{
  echo "A para a Vm, A Processar pedido, Aguarde"
}

Save-AzureVMImage   -ImageName $label  -Name $_.Name -ServiceName $_.Servicename  -ImageLabel $_.Name -OSState Specialized

$time = Get-Date -format G
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Data Source=10.108.82.6\inst02;;Initial Catalog=Ageasdev;user id=ageasAudit;Pwd=audit" 
$conn.open()
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.connection = $conn
$cmd.commandtext = "INSERT INTO Vmimages (vm,type,action,date) VALUES('$label','Specialized', 'BackupImage', '$time' )"
$cmd.executenonquery()
$conn.close()

start-azurevm  -ServiceName $_.Servicename -Name $_.Name  
while(Get-AzureVM -ServiceName $_.Servicename  -Name $_.Name | Where-Object { $_.Status -ne "ReadyRole"} )
{
  echo "A arrancar a Vm, A Processar pedido, Aguarde"
}

}


#region export vm Xml

Get-AzureVM | select name, servicename | ForEach-Object {
	
	$vm = Get-AzureVM  -ServiceName $_.Servicename -Name $_.Name
	$vmOSDisk = $vm | Get-AzureOSDisk
	$vmDataDisks = $vm | Get-AzureDataDisk
	
	$exportFolder = "F:\vmexport\"
	
	if (!(Test-Path -Path $exportFolder))
	{
		
		New-Item -Path $exportFolder -ItemType Directory
		
	}
	
	$exportPath = $exportFolder + "\" + $vm.Name + ".xml"
	
	$vm | Export-AzureVM -Path $exportPath
}
#endregion 