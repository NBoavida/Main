<#     
       .NOTES
       ===========================================================================
       Created by:        Frederico Frazão
       Organization:     Agap2
        Filename: Remove:my_-image
       ===========================================================================
       .DESCRIPTION
Remove um template da subscrição, e apaga os respectivos vhds
#>

Remove-AzureVMImage –ImageName Template_Sharepoint_2013_W2012R2_X64 –DeleteVHD;