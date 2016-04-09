###########################################################################
#
# NAME: CREATE AD-Accont 
#
# AUTHOR:  D333867  - Frederico Frazão
#
# COMMENT: Cria uma conta da AD
#
# VERSION HISTORY:
# 1.0 18-04-2012 - Initial release
#
###########################################################################
$displayname= Read-Host "Nome ?"
$Xnuc= Read-Host "XNUC ?"
$Department = 'DOIT'
$Company =  Read-Host 'Empresa ?'
$Alias=$xnuc
new-QADUser -name $displayname -ParentContainer 'OU=Team Users,OU=Users,OU=DOIT,OU=Data Management,DC=bcpcorp,DC=dev' -UserPassword 'P@ssword'-samAccountName $Xnuc -DisplayName $displayname -FirstName  $displayname 
set-qaduser -identity $alias -company $Company -department $Department -displayname $displayname 