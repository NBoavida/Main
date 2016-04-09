





[xml] $dhcp01 = gc D:\DHCP\Export\spf6001dhc01_1722297.xml
[xml] $dhcp02 = gc D:\DHCP\Export\spf6001dhc02_1722297.xml

#$dhcp01.DHCPServer.IPv4.Scopes.Scope.Leases.AppendChild($dhcp01.ImportNode(($dhcp02.DHCPServer.IPv4.Scopes.Scope), $true))
#$dhcp01.save('D:\ff\dhcp\new22.xml');

#ii 'D:\ff\dhcp\new22.xml';




$dhcp01.DHCPServer.IPv4.Scopes.AppendChild( $dhcp01.ImportNode(($dhcp02.DHCPServer.IPv4.Scopes.Scope) , $true))
$dhcp01.save('D:\ff\dhcp\new22.xml');