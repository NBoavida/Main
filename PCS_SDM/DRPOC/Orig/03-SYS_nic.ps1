
#set GW
New-NetRoute -InterfaceAlias FE -NextHop "10.11.19.1"-destinationprefix "0.0.0.0/0" -confirm:$false

# set new IP

$IP = "10.11.19.196"
$MaskBits = 24 # This means subnet mask = 255.255.255.0
$Gateway = "10.11.19.1"
$IPType = "IPv4"
$adapter = Get-NetAdapter | ? {$_.Status -eq "up"}

If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
    $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
}

If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
    $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
}

# Configure the IP address and default gateway
$adapter | New-NetIPAddress `
    -AddressFamily $IPType `
    -IPAddress $IP `
    -PrefixLength $MaskBits `
    -DefaultGateway $Gateway
