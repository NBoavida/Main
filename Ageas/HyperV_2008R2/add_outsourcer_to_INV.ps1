add-pssnapin sqlserverprovidersnapin100  -ErrorAction SilentlyContinue
add-pssnapin sqlservercmdletsnapin100 -ErrorAction SilentlyContinue
#$xnuc = Read-host "Please enter XNUC"
#$nome = Read-host "Please enter Name of XNUC"
#invoke-sqlcmd -query "INSERT [dbo].[Users_MZ] ([XNUC], [NOME]) VALUES (N'$xnuc', N'$Nome')" -database DOIT_INV -serverinstance 172.16.120.189\inst12
#invoke-sqlcmd -query "INSERT [dbo].[OUTSOURCERS] ([XNUC], [NOME], [DATA_ACT], [XNUC_ACT]) VALUES (N'$xnuc', N'$nome', NULL, NULL)" -database DOIT_INV -serverinstance 172.16.120.189\inst12

##invoke-sqlcmd -query "select * from grupos_ad" -database DOIT_INV -serverinstance 172.16.120.189\inst12


#YGAPBSGB12 – BSG - BackOffice Auto Update
invoke-sqlcmd -query "INSERT [dbo].[AD_GROUP] ([Ad_group], [Ambiente], [Notas], [solution]) VALUES (N'YGAPBSGB12', N'DEV', N'BackOffice Auto Update', N'BackOffice')" -database DOIT_INV -serverinstance 172.16.120.189\inst12
invoke-sqlcmd -query "INSERT [dbo].[AD_GROUP] ([Ad_group], [Ambiente], [Notas], [solution]) VALUES (N'YGAPBSGB12', N'PROD', N'BackOffice Auto Update', N'BackOffice')" -database DOIT_INV -serverinstance 172.16.120.189\inst12

invoke-sqlcmd -query "select * from grupos_ad where AD_GROUP = 'YGAPBSGB12'" -database DOIT_INV -serverinstance 172.16.120.189\inst12