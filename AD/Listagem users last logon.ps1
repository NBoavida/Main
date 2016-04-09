$h = @{Label="LastLogon";Expression={(Get-Date -Date ([DateTime]::FromFileTime([Int64]::Parse($_.lastlogontimestamp))) ).tostring("yyyy-MM-dd hh:mm:ss")}} 
$a=get-aduser -searchbase "DC=fidelidademundial,DC=com" -filter {samaccountname -like '*'}
$output=foreach ($b in $a)
    {
    Get-ADUser $b -Properties samaccountname,lastlogontimestamp | FT samaccountname,$h -HideTableHeaders -Wrap -AutoSize 
    }

$output >c:\temp\tomaaaaa.txt
