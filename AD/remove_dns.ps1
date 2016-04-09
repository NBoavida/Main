$NodeToDelete = 'SPSCERTAGE01'
$DNSServer = "spf6001dc11.fidelidademundial.com"
$ZoneName = "fidelidademundial.com"
$NodeDNS = $null
$NodeDNS = Get-DnsServerResourceRecord -ZoneName fidelidademundial.com -ComputerName spf6001dc11.fidelidademundial.com -Node SPSCERTAGE01 -RRType A -ErrorAction SilentlyContinue
if($NodeDNS -eq $null){
    Write-Host "No DNS record found" -ForegroundColor red
} else {
    Remove-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DNSServer -InputObject $NodeDNS -Force
    write-host "Registo de DNS $NodeToDelete Removido" -ForegroundColor green
}

#validação 
if($NodeDNS -eq $null){
    Write-Host "Validação DNS $NodeToDelete não encontrado " -ForegroundColor green
} else {
    write-host "Registo de DNS $NodeToDelete Encontrado, validar o processo" -ForegroundColor red
    }


     