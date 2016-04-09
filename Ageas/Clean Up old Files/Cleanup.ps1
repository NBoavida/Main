	###########################################################################
#
# NAME: Clean Up old Files
#
# AUTHOR:  Frederico Frazão
#
# COMMENT: Remove todos os ficheiros antigos de um path
#
# VERSION HISTORY:
# 1.0 4/14/2012 - Initial release
#
###########################################################################

$dias = Read-Host "Antriores aos últimos? (Dias)"
$path = Read-Host "Path?"
get-childItem $path | where-object { $_.LastWriteTime -lt (get-date).AddDays(-$dias) } | remove-item 

	Write-Host "Todos os ficheiros antriores a $dias dias foram removidos"
	#[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
[void][System.Windows.Forms.MessageBox]::Show("Todos os ficheiros antriores a $dias dias foram removidos","Doit IT TOOL")