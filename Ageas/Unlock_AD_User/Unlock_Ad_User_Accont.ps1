
Add-PSSnapin Quest.ActiveRoles.ADManagement
$XNUC = Read-Host
Unlock-QADUser $XNUC
	#[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
[void][System.Windows.Forms.MessageBox]::Show("O User $xnuc Foi desbloqueado","Doit IT TOOL" )

