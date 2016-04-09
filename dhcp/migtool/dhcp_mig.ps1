
#region Var
#var
    $scopetxt = "d:\ff\scripts\dhcp\migtool\scopes.txt" #txt com as scopes a migrar
    $dhcpexportxml = "d:\ff\scripts\dhcp\migtool\dhcp01.xml" #export dhcp1
    $dhcpexportxml2 = "d:\ff\scripts\dhcp\migtool\dhcp02.xml" #Export dhcp2
    $scopeid = gc  $scopetxt #ler as scopes a migrar
    $NOVODHCPXML = "d:\ff\scripts\dhcp\migtool\dhcp03.xml" #merge xml
    $dhcp1 = 'spf6001dhc01.fidelidademundial.com'
    $dhcp2 = 'spf6001dhc02.fidelidademundial.com'
    $dhcp3 = 'spf6001dhc03'
    $dhcp1netbios = 'spf6001dhc01'
    $dhcp2netbios = 'spf6001dhc02'
   Import-DhcpServer –ComputerName $dhcp3  -Leases –File $NOVODHCPXML -BackupPath D:\DHCP\Backup -Verbose

#endregion

#region Screen
        write-host "*****************************************************************************************" -ForegroundColor Yellow
        write-host "            DHCP MIGRATION TOOL" -ForegroundColor Yellow
        write-host "*****************************************************************************************" -ForegroundColor Yello
        write-host "      Migrate DHCP Scopes from File"  -ForegroundColor Cyan
        Write-Host "           scopes.txt exp:" 
        write-host "                         10.0.10.0" 
        write-host "                         10.0.20.0" 
        write-host ""
        write-host "*****************************************************************************************" -ForegroundColor yellow
        write-host "Settings " -ForegroundColor Green 
        write-host   "Scopes file:" -ForegroundColor Green $scopetxt
        write-host   "XML file:" -ForegroundColor Green  $NOVODHCPXML
        write-host   "Source $dhcp1, $dhcp2 Target $dhcp3"  -ForegroundColor Green
         write-host "
"
write-host "" 
 #endregion


 write-host "Start DHCP Migration Process" -ForegroundColor red -BackgroundColor green   

$choice = ""
while ($choice -notmatch "[y|n]"){
    $choice = read-host "Do you want to continue?  (Y/N)" -ErrorAction SilentlyContinue 
    }

if ($choice -eq "y"){

             Write-Host "A exportar DHCP Settings" -ForegroundColor Green 
             Export-DhcpServer -ComputerName $dhcp1  -Leases -File $dhcpexportxml -Force -Verbose 
             Export-DhcpServer -ComputerName $dhcp2  -Leases -File $dhcpexportxml2 -Force -Verbose 
             Write-Host "A exportar DHCP Settings Done!" -ForegroundColor red

      

            #merge XML
             
            Write-Host "Merge XML process" -ForegroundColor Green 
            [xml] $dhcp01xml = gc $dhcpexportxml
            [xml] $dhcp02xml  = gc $dhcpexportxml2

            $dhcp01xml.DHCPServer.IPv4.Scopes.Scope.AppendChild( $dhcp01xml.ImportNode(($dhcp02xml.DHCPServer.IPv4.Scopes.Scope) , $true))
            $dhcp01xml.save("$NOVODHCPXML");

            Write-Host "Merge XML process Done!" -ForegroundColor red

        
           #importar scopes

           Write-Host "Importing Scopes Process" -ForegroundColor Green 
           $scidIMP = gc -Path $scopeid
             $scidIMP | ForEach-Object {Import-DhcpServer  –ComputerName $dhcp3 -BackupPathD:\DHCP\Backup\ -File $NOVODHCPXML -Leases -ScopeId  $scidIMP }
                    
         Write-Host "Importing Scopes Process Done!" 
           
          # desactivar
          
            Write-Host "Desactivate Scopes $scidIMP @ $DHCP1 e $DHCP2" -ForegroundColor red
           $desactivarscope = gc -Path $scopeid 

            $desactivarscope |  ForEach-Object { netsh dhcp server \\$dhcp1netbios scope  $scidIMP set state 0 }
            $desactivarscope |  ForEach-Object { netsh dhcp server \\$dhcp2netbios scope  $scidIMP set state 0 }
         
             write-host "Completed DHCP Migration Process!!" -ForegroundColor red -BackgroundColor green 
            pause
    }
    
else {write-host "Editar Scopes"| notepad.exe $scopetxt }


