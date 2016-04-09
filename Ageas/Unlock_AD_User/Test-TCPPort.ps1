function Test-TCPPort {
	param (
		[parameter(Mandatory=$true)]
		[string] $ComputerName,
		
		[parameter(Mandatory=$true)]
		[string] $Port
	)
	
	try {
		$TimeOut = 5000
		$IsConnected = $false
		$Addresses = [System.Net.Dns]::GetHostAddresses($ComputerName) | ? {$_.AddressFamily -eq 'InterNetwork'}
		$Address = [System.Net.IPAddress]::Parse($Addresses)
		$Socket = New-Object System.Net.Sockets.TCPClient
		
		$Connect = $Socket.BeginConnect($Address, $Port, $null, $null)
		$Wait = $Connect.AsyncWaitHandle.WaitOne($TimeOut, $false)	
		
		if ( $Socket.Connected ) {
			$IsConnected = $true
			$Socket.Close()
		} else {
			$IsConnected = $false
		}
		
	} catch {
		Write-Debug $_
		$IsConnected = $false
	} finally {
		return $IsConnected
	}
}