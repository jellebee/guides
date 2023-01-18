#Create function to add/import the exchange module
function installrequiredmodules{
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
try {installrequiredmodules}catch{
Import-Module -Name ExchangeOnlineManagement
Import-Module -Name AzureAD
Import-Module -Name MSOnline}
function o365connection {
    # Connect to exchange
    try{
        Connect-ExchangeOnline -Credential $Cred
        Write-Host "We have connected to Exchange Online"
    }
    catch{
        Write-Host "An error has occurred:$($Error[0])"
    }
    # Connect to Msol
    try{
        Connect-MsolService -Credential $Cred
        Write-Host "We have connected to MSOL service"
    }
    catch{
        Write-Host "An error has occurred:$($Error[0])"
    }

    # Connect to AzureAd
    try{
        Connect-AzureAD -Credential $Cred
        Write-Host "We have connected to AzureAD"
    }
    catch{
        Write-Host "An error has occurred:$($Error[0])"
    }
    try{
        Import-PSSession $ExchangeSession -DisableNameChecking
        Write-Host "We have connected to Exchange Online"
    }
    catch{
        Write-Host "An error has occurred:$($Error[0])"
    }
}
$Cred = Get-Credential
try{o365connection}catch{Write-Host "An error has occurred $($Error[0])"}