<#
Hi Guys,

I made this script to get some basic compliancy searches done using powershell.
Hope this is useful!

#>
#Create function to add/import the exchange module
function installrequiredmodules
{
	#Install ExchangeOnline
	Install-Module -Name ExchangeOnlineManagement -Force
	Import-Module -Name ExchangeOnlineManagement
	return "Succesfully installed and imported the AzureAD and MSOnline modules"
}
function localcall
{
	$local = Read-Host -Prompt "Are you running the script locally? Say 'yes' or 'y' elsewise AZ connection will not be established."
	if ($local -eq "yes" -or $local -eq "y")
	{
		try
		{
			#Before doing anything, install the required modules (this also allows an automatic import)
			installrequiredmodules
			$succes = $true
		}
		catch
		{
			Write-Host "You probably did not install the module. Please use the Install-Module cmdlet or checkout the Install_AZ_Module_and_Connect script in GitHub"
		}
		if ($succes -eq $true)
		{
			try
			{
				#Connecting to the environment (A popup will appear)
				Connect-IPPSSession
				Write-Host "We have connected to Exchange Online"
			}
			catch
			{
				Write-Host "An error has occurred:$($Error[0])"
			}
		}
	}
}
function compliancesearch($CompliancySearchName, $DGContentQuestion, $DG, $Content)
{
	Write-Host "You selected Compliancy Search. What would you like to search for?"
	
	if ($CompliancySearchName.Length -lt 1)
	{
		$CompliancySearchName = Read-Host -Prompt "What would you like the name of the Compliancy search to be like? (Default will be the content-CompSearch)"
		if ($CompliancySearchName.Length -lt 1)
		{
			$CompliancySearchName = "content-CompSearch"
		}
	}
	if ($DGContentQuestion.Length -lt 1)
	{
		$DGContentQuestion = Read-Host -Prompt "If you would like to search for a DG (Distribution Group) press 0. For a specific subject/content press 1 and for specific contnt/subject in DG press 2"
	}
	if ($DGContentQuestion -eq 0)
	{
		#Requests the user to enter a DG
		
		if ($DG.Length -lt 1)
		{
			$DG = Read-Host -Prompt "What is the name of the specific DG you are searching for? (For instance Science Department)"
		}
		#This searches for everything in a certain DG
		New-ComplianceSearch -Name $CompliancySearchName -ExchangeLocation $DG
	}
	if ($DGContentQuestion -eq 1)
	{
		#Requests the user to enter a Content pattern
		if ($Content.Length -lt 1)
		{
			$Content = Read-Host -Prompt "What content are you searching for? (example: 'My' AND 'Project Toys')"
		}
		#This basically searches anywhere for the mentioned content
		New-ComplianceSearch -Name $CompliancySearchName -ContentMatchQuery $Content
	}
	if ($DGContentQuestion -eq 2)
	{
		#Requests the user to enter a DG
		if ($DG.Length -lt 1)
		{
			$DG = Read-Host -Prompt "What is the name of the specific DG you would like to search through?"
		}
		#Requests the user to enter a Content pattern
		if ($Content.Length -lt 1)
		{
			$Content = Read-Host -Prompt "What content are you searching for? (example: 'My' AND 'Project Toys')"
		}
		#This searches for specific content in a DG
		New-ComplianceSearch -Name $CompliancySearchName -ExchangeLocation $DG -ContentMatchQuery $Content
	}
}

if (localcall){
	
	<#If you already know what you need you can fill it out.
	There are 3 options:
	Option 0: Search through a DG for everything
	Option 1: Search through all content and subjects available
	Option 2: Search through all the content and subjects available within a certain DG
	Please set $DGContentQuestion to the right property where required.
	#>
	
	$CompliancySearchName = "My-Comp-Search"
	$DGContentQuestion = 1
	$DG = ""
	$Content = ""
	
	compliancesearch
}