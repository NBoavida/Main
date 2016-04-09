$cn = read-host "CN a Remover"

Remove-ADComputer -Identity $cn | Write-Output

