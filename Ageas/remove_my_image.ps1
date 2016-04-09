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

Remove-AzureVMImage –ImageName spazsp2013-02 –DeleteVHD;