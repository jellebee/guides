<#
Hi Guys,

I made this script to get some basic mailbox searches done using powershell.
Hope this is useful!

#>
#Create function to add/import the exchange module
function installrequiredmodules
{
	#Install ExchangeOnline
	Install-Module -Name ExchangeOnlineManagement -Force
	Import-Module -Name ExchangeOnlineManagement
	return "Succesfully installed and imported the Exchange online module"
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
			Write-Host "You probably did not install the module. Please use the Install-Module cmdlet."
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
#Export Function
function exportfunction {
    #Just to double check that you would like to export information
    $export = Read-host -Prompt "Would you like to export the information [y/n]?"
    if ($export -eq 'y') {
        return $export
        continue
    }
}
#Function for exportconfig
function exportpreperation {
    try {
        #Setting export path
        $path = "C:\Temp"
        #If the path is not set request the user for setting the path
        if ($path.length -lt 2) {
            $path = Read-Host -Prompt "What would you like the export path to be?"
        }
        #checking the directory exists and creating one where necessary
        If (!(test-path $path)) {
            New-Item -ItemType Directory -Force -Path $path
            Write-Host "A new export directory has been created at: $($path)"
        }

        $date = get-date -Format yyyyMMdd-HHmmss

        #Setting file name
        $filename = "IncidentList_$date.csv"
        if ($filename.length -lt 5) {
            $filename = Read-Host -Prompt "What would you like the (export) filename to be?"
        }
        $file = "$($path)\$($filename)"
        return $file
    }
    catch {
        Write-Error "I guess something went wrong in your export preperation"
        continue
    }
}
function getcompliancesearch($CompliancySearchName)
{
	Write-Host "You selected Get Compliancy Search. Which Compliancy search would you like to check?"
	
	if ($CompliancySearchName.Length -lt 1)
	{
		$CompliancySearchName = Read-Host -Prompt "What Compliancy Search would you like to search for? (If you would like to see everything please enter nothing here)"
		if ($CompliancySearchName.Length -lt 1)
		{
			$CompliancySearchName = ""
			Write-Host "We will now search for all compliancy searches"
			$compliancy = Get-ComplianceSearch
		}
		if($CompliancySearchName.Length -gt 2){
			Write-Host "We will now search for a compliancy search matching the identity $($CompliancySearchName)"
			$compliancy = Get-compliancy -Identity $CompliancySearchName
		}
	}
}

if (localcall -and exportfunction){
	
	<#If you already know what you need you can fill it out.
	There are 2 options:
	Option 0: Obtain a list of all compliancy searches
	Option 1: Obtain a specific compliancy search by entering the name below
	#>
	
	$CompliancySearchName = ""
	$exportpath = exportpreperation
	getcompliancesearch | Out-File -FilePath $exportpath -NoClobber -NoOverwrite -Force
}
else{
	<#If you already know what you need you can fill it out.
	There are 2 options:
	Option 0: Obtain a list of all compliancy searches
	Option 1: Obtain a specific compliancy search by entering the name below
	WITHOUT Export
	#>
	$CompliancySearchName = ""
	getcompliancesearch
}