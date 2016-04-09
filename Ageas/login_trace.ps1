$content = Get-Content C:\tmp\servers1.txt 
foreach ($line in $content)


{
  Write-host "$line make Dir "
    
    New-Item -ItemType directory -Path \\$line\c$\Packages\tools -ErrorAction SilentlyContinue

  Write-host "$line copy file "  
  Copy-Item '\\sdazop01\c$\Packages\tools\on.ps1'  \\$line\c$\Packages\tools\on.ps1  -Force

  Write-host "$line Deploy Reg "  
  $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $line ) 
        $regKey= $reg.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run",$true) 
        $regKey.SetValue("Login_trace","PowerShell.exe -windowstyle hidden  -ExecutionPolicy Unrestricted -f  C:\Packages\tools\on.ps1",[Microsoft.Win32.RegistryValueKind]::String) 

 
}
