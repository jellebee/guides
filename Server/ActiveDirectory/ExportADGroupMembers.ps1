#This script requires the ActiveDirectory module
Import-Module ActiveDirectory

#Select your group name
$groupname = "Domain Users"
#Set the export path to your preferred path
$exportpath = "C:\Temp\$($groupname).csv"
#Run the actual command
get-adgroup -Identity $groupname | Get-ADGroupMember | Select-Object Name | Export-Csv -Path $exportpath