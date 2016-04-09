   <#
    ======================================================================================================================================================
    ======================================================================================================================================================
    ======================================================================================================================================================

    ATENÇÃO PARA REMOVER UMA DAS MAQUINAS DO PROCESSO TEM DE SE REMOVER A LINHA, CASO SEJA COMENTADO O SCRIPT NÃO EXECUTA ATÉ AO FINAL 

    ======================================================================================================================================================
    ======================================================================================================================================================
    ======================================================================================================================================================
                                                    
.NOTES
	===========================================================================
	 Created on:   	20/10/2014 22:06
	 Created by:   	Frederico Frazão
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		Schedule task to start VM's Fom dev e  Qual 

Domain: Ageasdev.com
 Updated 21/01/2014
    -adicionado inserts na db 


#>

 Get-AzureVM  | Where-Object { `            $_.Name -like "SDAZSQL01" `         -or $_.Name -like "wdazsp2013-01" `
         -or $_.Name -like "sqazsp13-01" `
         -or $_.Name -like "SDAZFS01"`
         -or $_.Name -like "SDAZIIS01" `
         -or $_.Name -like "wdazvs03" `
         -or $_.Name -like "wdazvs02" `
         -or $_.Name -like "wdazvs01"  `
         -or $_.Name -like "WDVS2015"  `
         -or $_.Name -like "wdazsp2013-02"  `
	     -or $_.Name -like "wdazsp2013-03"  `
         -or $_.Name -like "wdazumbraco-01"  `
         -or $_.Name -like "SDAZAPP02"  `
           } | select name, servicename | ForEach-Object {
       
     start-azurevm  -ServiceName $_.Servicename -Name $_.Name  

$time = Get-Date -format G
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Data Source=10.108.82.6\inst02;;Initial Catalog=Ageasdev;user id=ageasAudit;Pwd=audit" 
$conn.open()
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.connection = $conn
$cmd.commandtext = "INSERT INTO ScheduleTask (Servicename,Action,source,date) VALUES('$_.Servicename','Start VM', 'SDAZOP02', '$time' )"
$cmd.executenonquery()
$conn.close()


}


