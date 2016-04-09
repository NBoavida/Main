###########################################################################
#
# NAME: Avg_ping.PS1
#
# AUTHOR:  D333867
#
# COMMENT:   Ping Multiple Server and get an Average Ping time 
#
# VERSION HISTORY:
# 1.0 12-04-2012 - Initial release
#
###########################################################################
$CompName = "172.16.120.124","172.16.120.126","172.16.120.128","172.16.120.115"

foreach ($comp in $CompName) {
	
	$test = (Test-Connection -ComputerName $comp -Count 4  | measure-Object -Property ResponseTime -Average).average
	$response = ($test -as [int] )
		
	write-Host "The Average response time for" -ForegroundColor Green -NoNewline;write-Host " `"$comp`" is " -ForegroundColor Red -NoNewline;;Write-Host "$response ms" -ForegroundColor Black -BackgroundColor white
	Write-Host "The Ping Has retuned suseccefuly with a Average Ping " 
}
