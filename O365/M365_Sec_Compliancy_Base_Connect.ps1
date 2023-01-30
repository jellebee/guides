#Create function to add/import the exchange module
function installrequiredmodules
{
	#Install ExchangeOnline
	Install-Module -Name ExchangeOnlineManagement -Force
	Import-Module -Name ExchangeOnlineManagement
	return "Succesfully installed and imported the Exchange Online module"
}
try { installrequiredmodules }
catch
{
	Import-Module -Name ExchangeOnlineManagement
}
function m365connection
{
	# Connect to exchange as this is required
	try
	{
		Connect-IPPSSession
		Write-Host "We have connected to Exchange Online"
	}
	catch
	{
		Write-Host "An error has occurred:$($Error[0])"
	}
}
m365connection