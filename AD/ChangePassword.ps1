# $newpwd = Read-Host "Enter the new password" –AsSecureString
# Ou 

$newpwd = ConvertTo-SecureString -String "654321a*" -AsPlainText -Force

$List = get-content .\ChangePasswordUsers.txt

$List | %{
			Set-ADAccountPassword $_ -NewPassword $newpwd -Reset -PassThru | Set-ADuser -ChangePasswordAtLogon $True
		}
