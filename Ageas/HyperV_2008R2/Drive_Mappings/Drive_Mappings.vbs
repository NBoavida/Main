Option Explicit

Dim WshNetwork

Set WshNetwork = CreateObject("WScript.Network")

InstallDrives

Set WshNetwork = Nothing


'**************************************************************
'    remove drives
'    add drives
'
'**************************************************************

Sub InstallDrives

    On Error Resume Next

    WshNetwork.RemoveNetworkDrive "G:", true, true
    WshNetwork.RemoveNetworkDrive "H:", true, true
    WshNetwork.RemoveNetworkDrive "Q:", true, true


     WshNetwork.MapNetworkDrive "G:", "\\setpsfifvs01.bcpcorp.net\global", False
     WshNetwork.MapNetworkDrive "H:", "\\SETPSFIFVS01\USERDATA\"+ WshNetwork.Username, False
     WshNetwork.MapNetworkDrive "Q:", "\\setpsfifvs01.bcpcorp.net\NNormalizadas", False


   
    'WshNetwork.MapNetworkDrive "G:", "\\setpsfifvs01.bcpcorp.net\global", False
    'WshNetwork.MapNetworkDrive "H:", "\\SETPSFIFVS01\USERDATA\"+ WshNetwork.Username, False
    'WshNetwork.MapNetworkDrive "Q:", "\\setpsfifvs01.bcpcorp.net\NNormalizadas", False




End sub