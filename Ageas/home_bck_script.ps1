###################################################
# Home Backup Script 
#07062013 - Inicial Version 
###################################################

#Region Homedir + backup Settings
$Homedir = "X:\_cleanup_fs_doit\"
$Backup = "X:\dailychecks\"
#endregion

#Region Log Dir + logfile Settings
$logdir = "X:\Cloud\"
new-item -type directory -path $logdir -ErrorAction SilentlyContinue 
$logfile = "X:\Cloud\\BCK_log2.txt"
new-item -path $logfile -type file  -ErrorAction SilentlyContinue 
mkdir $logdir -ErrorAction SilentlyContinue 
get-date | out-file $logfile 
[Environment]::UserName |  out-file $logfile -append
#endregion


Param ($Homedir,$Backup)  -ErrorAction SilentlyContinue 

function Get-FileMD5 {
    Param([string]$ficheiro)
    $FileMode = [System.IO.FileMode]("open")
    $FileAccess = [System.IO.FileAccess]("Read")
    $md5 = New-Object System.Security.Cryptography.MD5CryptoServiceProvider
    $FileStream = New-Object System.IO.FileStream($ficheiro,$FileMode,$FileAccess)
    $Hash = $md5.ComputeHash($FileStream)
    $FileStream.Close()
  [string]$Hash = $Hash
    Return $Hash
}


function Copy-LatestFile{
    Param($ficheiro1,$ficheiro2,[switch]$whatif)
    $ficheiro1Date = get-Item $ficheiro1 | foreach-Object{$_.LastWriteTimeUTC}
    $ficheiro2Date = get-Item $ficheiro2 | foreach-Object{$_.LastWriteTimeUTC}
    if($ficheiro1Date -gt $ficheiro2Date)
    {
        Write-Host "$ficheiro1 é Novo .. A copiar...."
        echo "$ficheiro1 é Novo .. A copiar...."  | out-file $logfile -append
        if($whatif){Copy-Item -path $ficheiro1 -dest $ficheiro2 -force -whatif}
        else{Copy-Item -path $ficheiro1 -dest $ficheiro2 -force}
    }
    else
    {
       
        #Write-Host "$ficheiro2 é Novo .. A copiar...."
        #if($whatif){Copy-Item -path $ficheiro2 -dest $ficheiro1 -force -whatif}
        #else{Copy-Item -path $ficheiro2 -dest $ficheiro1 -force}
    }
    Write-Host
    
}


$HomedirEntries = Get-ChildItem $Homedir -Recurse
$bckEntries = Get-ChildItem $Backup -Recurse


$Homedirfolders = $HomedirEntries | Where-Object{$_.PSIsContainer}
$HomedirFiles = $HomedirEntries | Where-Object{!$_.PSIsContainer}
$Backupfolders = $bckEntries | Where-Object{$_.PSIsContainer}
$backupsFiles = $bckEntries | Where-Object{!$_.PSIsContainer}


foreach($Pastas in $Homedirfolders)
{
    $HomedirPastaPath = $Homedir -replace "\\","\\" -replace "\:","\:"
    $BackupPastas = $Pastas.Fullname -replace $HomedirPastaPath,$Backup
    if(!(test-path $BackupPastas))
    {
        Write-Host "Pasta $BackupPastas Não existe. A criar!!!"
        echo "Pasta $BackupPastas Não existe. A criar!!!"  | out-file $logfile -append
        new-Item $BackupPastas -type Directory | out-Null
    }
}


#foreach($Pastas in $Backupfolders)
#{
#    $bckfilesPath = $Backup -replace "\\","\\" -replace "\:","\:"
#    $homedirPastas = $Pastas.Fullname -replace $bckfilesPath,$Homedir
#    if(!(test-path $homedirPastas))
#    {
#        Write-Host "Pasta $homedirPastas  Não existe. A criar!!!"
#          echo "Pasta $homedirPastas  Não existe. A criar!!!"  | out-file $logfile -append
#        new-Item $homedirPastas -type Directory | out-Null
#    }
#}


foreach($entry in $HomedirFiles)
{
    $SrcFullname = $entry.fullname
    $SrcName = $entry.Name
    $SrcFilePath = $Homedir -replace "\\","\\" -replace "\:","\:"
    $DesFile = $SrcFullname -replace $SrcFilePath,$Backup
    if(test-Path $Desfile)
    {
        $HomedirMD5 = Get-FileMD5 $SrcFullname
        $backupMD5 = Get-FileMD5 $DesFile
        If(Compare-Object $HomedirMD5 $backupMD5)
        {
            Write-Host "os ficheiros são difrentes... A validar datas"
            echo "os ficheiros são difrentes... A validar datas "  | out-file $logfile -append
            Write-Host $HomedirMD5
            Echo $HomedirMD5 | out-file $logfile -append
            Write-Host $backupMD5
            Echo $backupMD5 | out-file $logfile -append
            Copy-LatestFile $SrcFullname $DesFile
        }
    }
    else
    {
        Write-Host "$Desfile Não existe. A criar!!!. A copiar de $SrcFullname"
        Echo "$Desfile Não existe, a copiar de $SrcFullname" | out-file $logfile -append
        copy-Item -path $SrcFullName -dest $DesFile -force
    }
}


foreach($entry in $backupsFiles)
{
    $DesFullname = $entry.fullname
    $DesName = $entry.Name
    $bckfilesPath = $Backup -replace "\\","\\" -replace "\:","\:"
    $SrcFile = $DesFullname -replace $bckfilesPath,$Homedir
    if(!(test-Path $SrcFile))
    {
        Write-Host "$SrcFile Não existe, a copiar de $DesFullname"
        Echo "$SrcFile Não existe, a copiar de $DesFullname" | out-file $logfile -append
        copy-Item -path $DesFullname -dest $SrcFile -force
    }
}


#region Gmail Settings 
#$smtpClient = new-object system.net.mail.smtpClient 
#$smtpClient.Host = 'smtp.gmail.com'
#$smtpClient.Port = 587
#$smtpClient.EnableSsl = $true
#$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("frederico.frazao", "welcome!"); #gmail user sem @gmail.com
#
#$date = get-date
#$emailfrom = "frederico.frazao@gmail.com"
#$emailto = "frederico.frazao@suxsox.com"
#$subject = ($Text , $date )
#$Text = 'Home Auto-Backup (login) Executado'
#$body = "Log em anexo"
#
#
#$emailMessage = New-Object System.Net.Mail.MailMessage
#$emailMessage.From = $EmailFrom
#$emailMessage.To.Add($EmailTo)
#$emailMessage.Subject = $Subject
#$emailMessage.Body = $Body
#$emailMessage.Attachments.Add("X:\Cloud\\BCK_log2.txt")
#$SMTPClient.Send($emailMessage)

#endregion