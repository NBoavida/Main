	###########################################################################
#
# NAME: Radom pwd
#
# AUTHOR:  Frederico Frazão
#
#
# VERSION HISTORY:
# 1.0 4/14/2012 - Initial release
#
###########################################################################
Param 
	(
        #Defines the parameter for password length
		[Alias("PL")]
		[Alias("PassLen")]
		[Int]$PasswordLength = 9,
	
		#Defines the paramter for the complexity level of the password generated
		[Alias("CL")]
		[ValidateSet("H","M","L")]
		[String]$ComplexityLevel = "H"

			        
   )

Process 
	{
		
		# The array of characters below is used for the high complexity password generations
		$arrCharH = "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0","!","@","#","$","%","&","^","*","(",")","-","+","=","_","{","}","\","/","?","<",">"
		
		# The array of characters below is used for the medium complexity password generations
		$arrCharM = "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0"
		
		# The array of characters below is used for the low complexity password generations
		$arrCharL = "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"
		
		#Define the counter to be used in the for loop below
		$i = 1

		
		#Switch configuration to generate the appropriate complexity level defined by the -ComplexityLevel paramter
		Switch ($ComplexityLevel)
			{
				H { 
					For(; $i -le $PasswordLength; $i++)
						{
							$arrPass =  Get-Random -Input $arrCharH
							Write-Host $arrPass -NoNewLine
						}	
					Write-Host "`n"
				  }
				
				M { 
					For(; $i -le $PasswordLength; $i++)
						{
							$arrPass =  Get-Random -Input $arrCharM
							Write-Host $arrPass -NoNewLine
						}	
					Write-Host "`n"
				  }
				
				L { 
					For(; $i -le $PasswordLength; $i++)
						{
							$arrPass =  Get-Random -Input $arrCharL
							Write-Host $arrPass -NoNewLine
						}	
					Write-Host "`n"
				  }
				
			}	
	}