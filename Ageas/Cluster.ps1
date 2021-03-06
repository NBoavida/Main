# Define variables
$ClusterNetworkName = "AGHASQL01" # the cluster network name
$IPResourceName = "AGHASQL01_10.108.66.250" # the IP Address resource name 
$CloudServiceIP = "104.45.13.213" # IP address of your cloud service
Import-Module FailoverClusters

# If you are using Windows 2012 or higher, use the Get-Cluster Resource command. If you are using Windows 2008 R2, use the cluster res command. Both commands are commented out. Choose the one applicable to your environment and remove the # at the beginning of the line to convert the comment to an executable line of code. 

Get-ClusterResource $IPResourceName | Set-ClusterParameter -Multiple @{"Address"="104.45.13.213";"ProbePort"="59999";SubnetMask="255.255.255.0";"Network"="SPCLSSQL01";"OverrideAddressMatch"=1;"EnableDhcp"=0}



# cluster res $IPResourceName /priv enabledhcp=0 overrideaddressmatch=1 address=$CloudServiceIP probeport=59999  subnetmask=255.255.255.255

