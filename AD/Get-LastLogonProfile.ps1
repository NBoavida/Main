# Author: Rafael Duarte
# Purpose: Read location \\gcxjxxitrfs301\upload\SC and export data of lastLogon to CSV

$x_Path_LastLogon_Profile = "\\gcxjxxitrfs301\upload\SC"
$x_Path_LastLogon_csv = "d:\scripts\ad\LastLogon"
$x_File_LastLogon_csv = $x_Path_LastLogon_csv + "\LastLogon.csv"
$x_List = get-childitem $x_Path_LastLogon_Profile -name -file
#$x_List = "RDT0545.TXT"

$x_List | 
	#select -first 100 |
			%{
			$x_profile = get-content "$x_Path_LastLogon_Profile\$_"
			$x_linha = $_ | Select-Object -Property File, UserID, CN, Domain, DC, SO, LogonDate, LogonTime
			$x_linha.File = $_
			$x_linha.UserID = $x_profile[0].Split("-")[1].trim()
			$x_linha.CN = $x_profile[1].Split("-")[1].trim()
			$x_linha.Domain = $x_profile[2].Split("-")[1].trim()
			$x_linha.DC = ($x_profile[3].Split("-")[1].trim()).split('\\')[2]
			$x_linha.SO = $x_profile[4].Split("-")[1].trim()
			$x_linha.LogonDate = $x_profile[5].Split(" ")[6].trim()
			$x_linha.LogonTime = $x_profile[5].Split(" ")[8].trim()
			$x_linha | Export-csv $x_File_LastLogon_csv -Delimiter ";" -NoTypeinformation -append
			}
