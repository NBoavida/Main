

function Restart-ServiceEx {
	[CmdletBinding( SupportsShouldProcess=$true, ConfirmImpact='High')]
	param(
	$computername = 'localhost',
	$service = 'Spooler',
	$credential = $null
	)

 # create list of clear text error messages
	$errorcode = 'Success,Not Supported,Access Denied,Dependent Services Running,Invalid Service Control'
	$errorcode += ',Service Cannot Accept Control, Service Not Active, Service Request Timeout'
	$errorcode += ',Unknown Failure, Path Not Found, Service Already Running, Service Database Locked'
	$errorcode += ',Service Dependency Deleted, Service Dependency Failure, Service Disabled'
	$errorcode += ',Service Logon Failure, Service Marked for Deletion, Service No Thread'
	$errorcode += ',Status Circular Dependency, Status Duplicate Name, Status Invalid Name'
	$errorcode += ',Status Invalid Parameter, Status Invalid Service Account, Status Service Exists'
	$errorcode += ',Service Already Paused'

	# if credential was specified, use it...
	if ($credential) {
		$service = Get-WmiObject Win32_Service -ComputerName $computername -Filter "name=""$service""" -Credential $credential
	} else {
		# else do not use this parameter:
		$service = Get-WmiObject Win32_Service -ComputerName $computername -Filter "name=""$service""" 
	}

	# if service was running already...
	$servicename = $service.Caption
	if ($service.started) {
		# should action be executed? 
		if ($pscmdlet.ShouldProcess($computername, "Restarting Service '$servicename'")) {
   # yes, stop service:
			$rv = $service.StopService().ReturnValue
			if ($rv -eq 0) {
				# ...and if that worked, restart again
				$rv = $service.StartService().ReturnValue
			}
   # return clear text error message:
			$errorcode.Split(',')[$rv]
		} 
	} else {
		# else if service was not running yet, start it:
		if ($pscmdlet.ShouldProcess($computername, "Starting Service '$servicename'")) {
			$rv = $service.StartService().ReturnValue
			$errorcode.Split(',')[$rv]
		} 
	}
} 

