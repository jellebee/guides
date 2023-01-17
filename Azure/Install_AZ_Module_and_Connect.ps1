#Make sure you allow remotesigned script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

#By Default this will install the Azure module through the Powershell Gallery
Install-Module -Name Az -Force

#Import the module just in case
Import-Module -Name Az

#To connect to azure login through here after trying to install the module
Connect-AzAccount