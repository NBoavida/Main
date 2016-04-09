

$then = (Get-Date).AddDays(-60) # The 60 is the number of days from today since the last logon.

Get-ADComputer -Property Name,lastLogonDate -Filter {lastLogonDate -lt $then} | FT Name,lastLogonDate 
# If you would like to Disable these computer accounts, uncomment the following line:
# Get-ADComputer -Property Name,lastLogonDate -Filter {lastLogonDate -lt $then} | Set-ADComputer -Enabled $false

# If you would like to Remove these computer accounts, uncomment the following line:
# Get-ADComputer -Property Name,lastLogonDate -Filter {lastLogonDate -lt $then} | Remove-ADComputer

#efetuado
#Get-Content D:\Scripts\AD\removerCN.txt | % { Get-ADComputer -Filter { Name -eq $_ } } | Remove-adobject -Recursive