1- criar um ficheiro de txt com a password e copiar para dll

echo password > c:\winnt\system32\bla.txt
copy c:\winnt\system32\bla.txt c:\winnt\system32\bla.dll
del c:\winnt\system32\bla.txt

2-  ps script para mapear drives 

#criar variavel para ler o conteudo da dll 
$fred = get-content c:\winnt\system32\bla.dll

$DOIT1GEN = 'bcpcorp.net\DOIT1GEN'

$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("B:", "\\setpsfifvs01.bcpcorp.net\NNormalizadas\DOIT-Passagens", $false, $DOIT1GEN, $fred )

