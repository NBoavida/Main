Install-WindowsFeature Net-Framework-Core -source \\10.108.66.7\hasd01\sxs






PS C:\Users\adminazdoit> net share sxs=C:\sxs
sxs was shared successfully.

PS C:\Users\adminazdoit> Install-WindowsFeature Net-Framework-Core -source \\10.108.82.6\sxs

Success Restart Needed Exit Code      Feature Result
------- -------------- ---------      --------------
True    No             Success        {.NET Framework 3.5 (includes .NET 2.0 and...
