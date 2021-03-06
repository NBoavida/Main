###################################################
# Home Backup Script 
#07062013 - Inicial Version 
###################################################
$Source = "D:\Homedir\"
$Destination = "D:\Backup_Homedir\"

#Region Log Dir + logfile
$logdir = "D:\DataStore\Scripts\Logdir\"
new-item -type directory -path $logdir -ErrorAction SilentlyContinue 
$logfile = "D:\DataStore\Scripts\Logdir\BCK_log.txt"
new-item -path $logfile -type file  -ErrorAction SilentlyContinue 
mkdir $logdir -ErrorAction SilentlyContinue 
get-date | out-file $logfile 
#endregion
###################################################
###################################################
Param ($Source,$Destination)

function Get-FileMD5 {
    Param([string]$file)
    $mode = [System.IO.FileMode]("open")
    $access = [System.IO.FileAccess]("Read")
    $md5 = New-Object System.Security.Cryptography.MD5CryptoServiceProvider
    $fs = New-Object System.IO.FileStream($file,$mode,$access)
    $Hash = $md5.ComputeHash($fs)
    $fs.Close()
  [string]$Hash = $Hash
    Return $Hash
}
function Copy-LatestFile{
    Param($File1,$File2,[switch]$whatif)
    $File1Date = get-Item $File1 | foreach-Object{$_.LastWriteTimeUTC}
    $File2Date = get-Item $File2 | foreach-Object{$_.LastWriteTimeUTC}
    if($File1Date -gt $File2Date)
    {
        Write-Host "$File1 is Newer... Copying..."
        echo "$File1 is Newer... Copying..."  | out-file $logfile -append
        if($whatif){Copy-Item -path $File1 -dest $File2 -force -whatif}
        else{Copy-Item -path $File1 -dest $File2 -force}
    }
    else
    {
        #Don't want to copy this in my case..but good to know
        #Write-Host "$File2 is Newer... Copying..."
        #if($whatif){Copy-Item -path $File2 -dest $File1 -force -whatif}
        #else{Copy-Item -path $File2 -dest $File1 -force}
    }
    Write-Host
    
}

# Getting Files/Folders from Source and Destination
$SrcEntries = Get-ChildItem $Source -Recurse
$DesEntries = Get-ChildItem $Destination -Recurse

# Parsing the folders and Files from Collections
$Srcfolders = $SrcEntries | Where-Object{$_.PSIsContainer}
$SrcFiles = $SrcEntries | Where-Object{!$_.PSIsContainer}
$Desfolders = $DesEntries | Where-Object{$_.PSIsContainer}
$DesFiles = $DesEntries | Where-Object{!$_.PSIsContainer}

# Checking for Folders that are in Source, but not in Destination
foreach($folder in $Srcfolders)
{
    $SrcFolderPath = $source -replace "\\","\\" -replace "\:","\:"
    $DesFolder = $folder.Fullname -replace $SrcFolderPath,$Destination
    if(!(test-path $DesFolder))
    {
        Write-Host "Folder $DesFolder Missing. Creating it!"
        echo "Folder $DesFolder Missing. Creating it!"  | out-file $logfile -append
        new-Item $DesFolder -type Directory | out-Null
    }
}

# Checking for Folders that are in Destinatino, but not in Source
foreach($folder in $Desfolders)
{
    $DesFilePath = $Destination -replace "\\","\\" -replace "\:","\:"
    $SrcFolder = $folder.Fullname -replace $DesFilePath,$Source
    if(!(test-path $SrcFolder))
    {
        Write-Host "Folder $SrcFolder Missing. Creating it!"
          echo "Folder $SrcFolder Missing. Creating it!"  | out-file $logfile -append
        new-Item $SrcFolder -type Directory | out-Null
    }
}

# Checking for Files that are in the Source, but not in Destination
foreach($entry in $SrcFiles)
{
    $SrcFullname = $entry.fullname
    $SrcName = $entry.Name
    $SrcFilePath = $Source -replace "\\","\\" -replace "\:","\:"
    $DesFile = $SrcFullname -replace $SrcFilePath,$Destination
    if(test-Path $Desfile)
    {
        $SrcMD5 = Get-FileMD5 $SrcFullname
        $DesMD5 = Get-FileMD5 $DesFile
        If(Compare-Object $srcMD5 $desMD5)
        {
            Write-Host "The Files MD5's are Different... Checking Write
            Dates"
            echo "The Files MD5's are Different... Checking Write Dates"  | out-file $logfile -append
            Write-Host $SrcMD5
            Echo $SrcMD5 | out-file $logfile -append
            Write-Host $DesMD5
            Echo $DesMD5 | out-file $logfile -append
            Copy-LatestFile $SrcFullname $DesFile
        }
    }
    else
    {
        Write-Host "$Desfile Missing... Copying from $SrcFullname"
        Echo "$Desfile Missing... Copying from $SrcFullname" | out-file $logfile -append
        copy-Item -path $SrcFullName -dest $DesFile -force
    }
}

# Checking for Files that are in the Destinatino, but not in Source
foreach($entry in $DesFiles)
{
    $DesFullname = $entry.fullname
    $DesName = $entry.Name
    $DesFilePath = $Destination -replace "\\","\\" -replace "\:","\:"
    $SrcFile = $DesFullname -replace $DesFilePath,$Source
    if(!(test-Path $SrcFile))
    {
        Write-Host "$SrcFile Missing... Copying from $DesFullname"
        Echo "$SrcFile Missing... Copying from $DesFullname" | out-file $logfile -append
        copy-Item -path $DesFullname -dest $SrcFile -force
    }
}
$smtpClient = new-object system.net.mail.smtpClient 
$smtpClient.Host = 'smtp.gmail.com'
$smtpClient.Port = 587
$smtpClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("frederico.frazao", "welcome!");

$date = get-date
$emailfrom = "frederico.frazao@gmail.com"
$emailto = "frederico.frazao@suxsox.com"
$subject = ($Texto, $date )
$Texto = 'Home Auto-Backup (login) Executado'
$body = "Here it goes :)"

$emailMessage = New-Object System.Net.Mail.MailMessage
$emailMessage.From = $EmailFrom
$emailMessage.To.Add($EmailTo)
$emailMessage.Subject = $Subject
$emailMessage.Body = $Body
$emailMessage.Attachments.Add("D:\DataStore\Scripts\Logdir\BCK_log.txt")
$SMTPClient.Send($emailMessage)