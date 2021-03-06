#============================================================================================
# Created on:   2014-04-14 
# Created by:   D333867
# Organization:  DOIT
# Filename:  AreaPassagens_Hist.ps1 
# version 0.2
# Description: 
#		- Mapea Drive Area de Passagens
#		- mapea Drive de Historio
#		- Copia ficheiros com mais de 90 dias para o historico na Area de Passagens 
# 		- Elimina ficheiros com mais de 90 dias da Area de passagens
# 		- Elimina ficheiros com mais de 180 dias do Historico 
#
#	- Update 16-04-2014  - Version 0.2
#		-Adicionado função de Log 
#		-Adicionado Enviar Notificação
#
##	- Buxfix 17-04-2014  - Add Zip
#
#==========================================================================================


#region Params Start

Remove-Item "C:\Purga\AreaPassagensCleanUp.log" -ErrorAction SilentlyContinue
Remove-Item "C:\Purga\AreaPassagensCleanUp.zip" -ErrorAction SilentlyContinue

start-transcript -path 'C:\Purga\AreaPassagensCleanUp.log'

#endregion


#region mapear Drives de Rede
#mapear Área de Passagens 
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("B:", "\\setpsfifvs01.bcpcorp.net\NNormalizadas\DOIT-Passagens", $false, "bcpcorp.net\DOIT1GEN", "16042014")

#mapear Historico Área de Passagens 
$net1 = new-object -ComObject WScript.Network
$net1.MapNetworkDrive("K:", "\\172.16.120.239\g$\AreapassagensHistorico", $false, "bcpcorp.DEV\D333867", "!!!!!!!!!!!!!!!!!9")
#endregion

#region Váriaveis
$pathNET = 'b:\' #Drive área passagens PRD historico
$pathCld = 'k:\' #Drive árra Passagens QUAL historico
$log = "C:\purga\AreaPassagensCleanUp.log"
#endregion

#region Copiar Ficheiros identificados (+90 dias)  para Cloud

#AIA 
$AIAFSPRD =  'b:\AIA\PRODUCAO\_HIST\'
$AIAFSQUAL =  'B:\AIA\QUALIDADE\_HISt\'
$AIACLDPRD = 'K:\AIA\PRODUCAO\_HIST\'
$AIACLDQUAL =  'K:\AIA\QUALIDADE\_HISt\'
MKDIR $AIACLDPRD  -ErrorAction SilentlyContinue 
MKDIR $AIACLDQUAL -ErrorAction SilentlyContinue 
Get-ChildItem -path $AIAFSPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $AIACLDPRD -Recurse  
Get-ChildItem -path $AIAFSQUAL  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $AIACLDQUAL -Recurse  
#BNKS-IENGINE
$BNKSFS = 'B:\BNKS-IENGINE\_HISt' 
$BNKSCLD = 'K:\BNKS-IENGINE\_HISt'
Mkdir $BNKSCLD -ErrorAction SilentlyContinue 
Get-ChildItem -path $BNKSFS  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $BNKSCLD -Recurse 
#Brokerseguros
$brkDRPFSPRD = 'B:\BrokerSeguros\DRP\_hist'
$brkDRPCLD = 'K:\BrokerSeguros\DRP\_hist'
$BRKFSPRD= 'B:\BrokerSeguros\Producao\_zhist'
$BRKCLDPRD= 'K:\BrokerSeguros\Producao\_zhist'
$BRKFSQUAL= 'B:\BrokerSeguros\Qualidade\_Hist'
$BRKCLDQUAL= 'K:\BrokerSeguros\Qualidade\_Hist'
#create Folders
Mkdir  $brkDRPCLD -ErrorAction SilentlyContinue 
mkdir $BRKCLDPRD -ErrorAction SilentlyContinue 
Mkdir $BRKCLDQUAL -ErrorAction SilentlyContinue 
Get-ChildItem -path $brkDRPFSPRD   | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $brkDRPCLD -Recurse  
Get-ChildItem -path $BRKFSPRD   | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $BRKCLDPRD -Recurse  
Get-ChildItem -path $BRKFSQUAL   | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $BRKCLDQUAL -Recurse  
#BSG
$BSGFSPRD = 'B:\BSG\Producao\_hist'
$BSGCLPRD = 'k:\BSG\Producao\_hist'
$BSGFSQUAL = 'B:\BSG\Qualidade\_hist\'
$BSGCLQUAL = 'k:\BSG\Qualidade\_hist\'
mkdir $BSGCLPRD -ErrorAction SilentlyContinue 
mkdir  $BSGCLQUAL -ErrorAction SilentlyContinue 
Get-ChildItem -path $BSGFSPRD   | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $BSGCLPRD -Recurse  
Get-ChildItem -path $BSGFSQUAL   | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $BSGCLQUAL -Recurse 
#EvoFlow
$EVOFSqlt= 'B:\Evolflow\Qualidade\_HIST'
$EVOFSPRD= 'B:\Evolflow\Produção\_HIST'
$EVOCLqlt= 'K:\Evolflow\Qualidade\_HIST'
$EVOCLPRD= 'K:\Evolflow\Produção\_HIST'
Mkdir $EVOCLqlt -ErrorAction SilentlyContinue 
mkdir $EVOCLPRD  -ErrorAction SilentlyContinue 
Get-ChildItem -path $EVOFSqlt   | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $EVOCLqlt -Recurse  
Get-ChildItem -path $EVOFSPRD   | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $EVOCLPRD -Recurse  
#facets
$facetsPRD = 'B:\Facets\Hist'
$facetsCLD = 'k:\Facets\Hist'
Mkdir $facetsCLD  -ErrorAction SilentlyContinue 
Get-ChildItem -path $facetsPRD   | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $facetsCLD -Recurse  
#GIS-GA
$GISGAPRD = 'B:\GIS-GA\PRODUCAO\_HIST'
$GISGACLD= 'k:\GIS-GA\PRODUCAO\_HIST'
Mkdir $GISGACLD  -ErrorAction SilentlyContinue
Get-ChildItem -path $GISGAPRD   | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $GISGACLD -Recurse  
#IP_Intranet
$IPITRAPRD = 'B:\IP_Intranet\PRODUCAO\_HIST'
$IPITRACL = 'k:\IP_Intranet\PRODUCAO\_HIST'
Mkdir $IPITRACL  -ErrorAction SilentlyContinue
Get-ChildItem -path $IPITRAPRD   | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $IPITRACL -Recurse  
$IPITRAQLT = 'B:\IP_Intranet\QUALIDADE\_HIST'
$IPITRAQLTCD = 'k:\IP_Intranet\QUALIDADE\_HIST'
Mkdir $IPITRAQLTCD  -ErrorAction SilentlyContinue
Get-ChildItem -path $IPITRAQLT   | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $IPITRAQLTCD -Recurse  
#IP_Mediators
$IPmedFSPRD = 'B:\IP_Mediators\PRODUCAO\_hist'
$IPmedCLDPRD = 'K:\IP_Mediators\PRODUCAO\_hist'
Mkdir $IPmedCLDPRD  -ErrorAction SilentlyContinue
Get-ChildItem -path $IPmedFSPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $IPmedCLDPRD -Recurse  
$IPmedFSqual = 'B:\IP_Mediators\QUALIDADE\_hist'
$IPmedCLqual = 'K:\IP_Mediators\QUALIDADE\_hist'
Mkdir $IPmedCLqual  -ErrorAction SilentlyContinue
Get-ChildItem -path $IPmedFSqual  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $IPmedCLqual -Recurse  
#IP_medis
$medisfsprd = 'B:\IP_Medis\Producao\_hist'
$medisCLprd = 'k:\IP_Medis\Producao\_hist'
Mkdir $medisCLprd  -ErrorAction SilentlyContinue
Get-ChildItem -path $medisfsprd  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $medisCLprd -Recurse  
$medisfsQLT = 'B:\IP_Medis\Qualidade\_hist'
$medisCLQLT = 'K:\IP_Medis\Qualidade\_hist'
Mkdir $medisCLQLT  -ErrorAction SilentlyContinue
Get-ChildItem -path $medisfsQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $medisCLQLT -Recurse  
#IP_MSProviders
$IP_MSProvidersFSPRD = 'B:\IP_MSProviders\Producao\_Historico'
$IP_MSProvidersCLPRD = 'k:\IP_MSProviders\Producao\_Historico'
Mkdir $IP_MSProvidersCLPRD  -ErrorAction SilentlyContinue
Get-ChildItem -path $IP_MSProvidersFSPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $IP_MSProvidersCLPRD -Recurse  
$IP_MSProvidersFSQLT = 'B:\IP_MSProviders\Qualidade\_Historico'
$IP_MSProvidersCLDQLT= 'K:\IP_MSProviders\Qualidade\_Historico'
Mkdir $IP_MSProvidersCLDQLT  -ErrorAction SilentlyContinue
Get-ChildItem -path $IP_MSProvidersFSQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $IP_MSProvidersCLDQLT -Recurse  

#Ip_ocidental
$ipocidentalFSPRD = 'B:\IP_Ocidental\Producao\_Hist'
$ipocidentalCLPRD = 'K:\IP_Ocidental\Producao\_Hist'
Mkdir $ipocidentalCLPRD  -ErrorAction SilentlyContinue
Get-ChildItem -path $ipocidentalFSPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $ipocidentalCLPRD -Recurse  
$ipocidentalFSQLT = 'B:\IP_Ocidental\Qualidade\_History'
$ipocidentalCLQLT = 'K:\IP_Ocidental\Qualidade\_History'
Mkdir $ipocidentalCLQLT  -ErrorAction SilentlyContinue
Get-ChildItem -path $ipocidentalFSQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $ipocidentalCLQLT -Recurse  

#IP_PSG
$PSGFSPRD = 'B:\IP_PensoesGere\Producao\_Historico'
$PSGCLPRD = 'K:\IP_PensoesGere\Producao\_Historico'
mkdir $PSGCLPRD -ErrorAction SilentlyContinue
Get-ChildItem -path $PSGFSPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $PSGCLPRD -Recurse  
$PSGFSQLT = 'B:\IP_PensoesGere\Qualidade\_Historico'
$PSGCLQLT = 'k:\IP_PensoesGere\Qualidade\_Historico'
mkdir $PSGCLQLT -ErrorAction SilentlyContinue
Get-ChildItem -path $PSGFSQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $PSGCLQLT -Recurse  
#Maaps
$mappsfsprd = 'B:\MAppS\Producao\Materiais\_hist'
$mappsCLDprd = 'k:\MAppS\Producao\Materiais\_hist'
mkdir $mappsCLDprd -ErrorAction SilentlyContinue
Get-ChildItem -path $mappsfsprd  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $mappsCLDprd -Recurse  

$mappsFSQLT = 'B:\MAppS\Qualidade\Materiais\_hist'
$mappsCLQLT = 'K:\MAppS\Qualidade\Materiais\_hist'
mkdir $mappsCLQLT -ErrorAction SilentlyContinue
Get-ChildItem -path $mappsFSQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $mappsCLQLT -Recurse  

#Siebel
$siebelfsprd = 'B:\Siebel\Producao\_hist'
$siebelCLprd = 'K:\Siebel\Producao\_hist'
mkdir $siebelCLprd -ErrorAction SilentlyContinue
Get-ChildItem -path $siebelfsprd  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $siebelCLprd -Recurse  
$siebelfsQLT = 'B:\Siebel\Qualidade\_hist'
$siebelclQLT = 'K:\Siebel\Qualidade\_hist'
mkdir $siebelclQLT -ErrorAction SilentlyContinue
Get-ChildItem -path $siebelfsQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | Copy-Item -destination $siebelclQLT -Recurse  
#endregion 


 

#Region Purgar Histórico 

#AIA Cloud
Get-ChildItem -path $AIACLDQUAL  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#AIA FS
Get-ChildItem -path $AIAFSPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $AIAFSQUAL  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#BNKS-IENGINE CLOUD
Get-ChildItem -path $BNKSCLD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#BNKS-IENGINE FS
Get-ChildItem -path $BNKSFS  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#Brokerseguros Cloud
Get-ChildItem -path $brkDRPCLD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $BRKCLDPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $BRKCLDQUAL  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#Brokerseguros FS
Get-ChildItem -path $BRKFSPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item   -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $brkDRPFSPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $BRKFSQUAL  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#BSG Cloud
Get-ChildItem -path $BSGCLPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $BSGCLQUAL  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#BSG FS
Get-ChildItem -path $BSGFSQUAL  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $BSGFSPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#EvoFlow Cloud
Get-ChildItem -path $EVOCLqlt  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $EVOCLPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#evoflow FS
Get-ChildItem -path $EVOFSqlt  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $EVOFSPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#facets Cloud 
Get-ChildItem -path $facetsCLD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#facets FS
Get-ChildItem -path $facetsPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#GIS-GA FS 
Get-ChildItem -path $GISGAPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#GIS-GA CLOUD
Get-ChildItem -path $GISGACLD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#IP_Intranet FS 
Get-ChildItem -path $IPITRAPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $IPITRAQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#IP_Intranet Cloud
Get-ChildItem -path $IPITRACL  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $IPITRAQLTCD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#IP_Mediators FS 
Get-ChildItem -path $IPmedFSPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $IPmedFSqual  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#IP_Mediators Cloud 
Get-ChildItem -path $IPmedCLDPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $IPmedCLqual  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#IP_medis Cloud
Get-ChildItem -path $medisCLprd  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $medisCLQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#IP_medis FS 
Get-ChildItem -path $medisfsprd  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $medisfsQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#IP_MSProviders FS 
Get-ChildItem -path $IP_MSProvidersFSPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $IP_MSProvidersFSQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#IP_MSProviders Cloud 
Get-ChildItem -path $IP_MSProvidersCLPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $IP_MSProvidersCLDQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#Ip_ocidental FS
Get-ChildItem -path $ipocidentalFSPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $ipocidentalFSQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#Ip_ocidental Cloud 
Get-ChildItem -path $ipocidentalCLPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $ipocidentalCLQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#IP_PSG FS
Get-ChildItem -path $PSGFSPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $PSGFSQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#IP_PSG Cloud 
Get-ChildItem -path $PSGCLQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $PSGCLPRD  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#Maaps FS
Get-ChildItem -path $mappsfsprd  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $mappsFSQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#Maaps Cloud
Get-ChildItem -path $mappsCLDprd  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $mappsCLQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#Siebel FS
Get-ChildItem -path $siebelfsprd  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $siebelfsQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-90)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#Siebel Cloud
Get-ChildItem -path $siebelCLprd  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
Get-ChildItem -path $siebelclQLT  | where-object {$_.lastwritetime -lt (Get-Date).Adddays(-180)} | remove-item  -ErrorAction SilentlyContinue -Force -Recurse
#endregion

 


#region Params Finnish
Stop-Transcript
#endregion

#region Params ZIP
$DestZip='C:\purga\'
$Dest = "C:\purga\AreaPassagensCleanUp.log"
$ZipTimestamp = Get-Date -format yyyy-MM-dd-HH-mm-ss;
$ZipFileName  = $DestZip + "AreaPassagensCleanUp"  + ".zip" 
set-content $ZipFileName ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18)) 
# Wait for the zip file to be created.
while (!(Test-Path -PathType leaf -Path $ZipFileName))
{    
    Start-Sleep -Milliseconds 20
} 
$ZipFile = (new-object -com shell.application).NameSpace($ZipFileName)

Write-Output (">> Waiting Compression : " + $ZipFileName)       
$ZipFile.MoveHere($Dest) 

 Start-Sleep -Milliseconds 10000
 
while (!(Test-Path -PathType leaf -Path C:\purga\AreaPassagensCleanUp.zip))
{    
    Start-Sleep -Milliseconds 2000
} 

#endregion

#region SendNotification
Add-PSSnapin Microsoft.Exchange.Management.Powershell.Admin -erroraction silentlyContinue
$batch_date = Get-Date
$file = "C:\Purga\AreaPassagensCleanUp.zip"
$smtpServer = "applsmtp.bcpcorp.dev"
$att = new-object Net.Mail.Attachment($file)
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$msg.From = "CleanUpAreaPassagens@bcpcorp.dev"
$msg.To.Add("fredericofrazao.agap2@millenniumbcp.pt, joaomoreira.agap2@millenniumbcp.pt")
$msg.Subject = "[CleanUP] AreaPassagens Histórico $batch_date"
$msg.Body = "Cleanup Executada  "
$msg.Attachments.Add($att)
$smtp.Send($msg)
$att.Dispose()
