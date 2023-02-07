#Create function to add/import the exchange module
function installrequiredmodules
{
	#Install ExchangeOnline
	Install-Module -Name ExchangeOnlineManagement -Force
	Import-Module -Name ExchangeOnlineManagement
	#Install MSOnline
	Install-Module -Name MSOnline -Force
	Import-Module -Name MSOnline
	#Install AzureAD
	Install-Module -Name AzureAD -Force
	Import-Module -Name AzureAD
	return "Succesfully installed and imported the AzureAD and MSOnline modules"
}
try { installrequiredmodules }
catch
{
	Import-Module -Name ExchangeOnlineManagement
	Import-Module -Name AzureAD
	Import-Module -Name MSOnline
}
function o365connection
{
	# Connect to exchange
	try
	{
		Connect-ExchangeOnline -Credential $Cred
		Write-Host "We have connected to Exchange Online"
	}
	catch
	{
		Write-Host "An error has occurred:$($Error[0])"
	}
	# Connect to Msol
	try
	{
		Connect-MsolService -Credential $Cred
		Write-Host "We have connected to MSOL service"
	}
	catch
	{
		Write-Host "An error has occurred:$($Error[0])"
	}
	
	# Connect to AzureAd
	try
	{
		Connect-AzureAD -Credential $Cred
		Write-Host "We have connected to AzureAD"
	}
	catch
	{
		Write-Host "An error has occurred:$($Error[0])"
	}
	try
	{
		Import-PSSession $ExchangeSession -DisableNameChecking
		Write-Host "We have connected to Exchange Online"
	}
	catch
	{
		Write-Host "An error has occurred:$($Error[0])"
	}
}
function changemailboxtype($User, $Type)
{
	if ($Type.Length -lt 2)
	{
		Read-Host -Prompt "If you would like to switch a shared to a user mailbox type User or user.`nIf you would like to switch a user mailbox to a shared mailbox type Shared or shared"
	}
	if ($Type -like '*egular*' -or $Type -like '*ser*')
	{
		$Type = "Regular"
	}
	if ($Type -like '*hared*')
	{
		$Type = "Shared"
	}
	if($User.Length -lt 2){
		$User = Read-Host -Prompt "Which User's mailbox would you like to change?"
	}
	try
	{
		Get-mailbox -identity $User | Set-mailbox -Type $Type
	}
	catch
	{
		Write-Host "An error has occurred.. `n $($Error[0])"
	}
	
}
$Cred = Get-Credential
if (o365connection)
{
	#Set the user or it will be asked!
	$User = ""
	#Set the type you want to change it to! Type Shared will make it a shared mailbox. Type User or Regular to make it a user mailbox (NOTE::: A USER MAILBOX REQUIRES A LICENSE.)
	$Type = ""
	
	changemailboxtype
}