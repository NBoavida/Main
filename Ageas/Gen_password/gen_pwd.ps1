
	

$alphabet=$NULL;For ($a=65;$a –le 90;$a++) {$alphabet+=,[char][byte]$a }

Function GET-Temppassword() {
 
Param(
 
[int]$length=10,
 
[string[]]$sourcedata
 
)
 
 
 
For ($loop=1; $loop –le $length; $loop++) {
 
            $TempPassword+=($sourcedata | GET-RANDOM)
 
            }
 
return $TempPassword
 
}

$oops= GET-Temppassword –length 8 –sourcedata $alphabet
$oops | Out-File random.txt
	#[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
[void][System.Windows.Forms.MessageBox]::Show("$oops","Doit IT TOOL")

invoke-Expression "notepad.exe random.txt" 
 
	
