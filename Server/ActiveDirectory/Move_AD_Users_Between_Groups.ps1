#Trying to import the active directory module
try{
	Import-module ActiveDirectory
}
catch{
	break
}
Write-Host "Hello, Welcome to this beautiful script!"
$identitySource = Read-Host "Please enter your Source groupname?"
$identityDestination = Read-Host "Please enter your Destination groupname?"
$Sourcegroupuser = Get-adgroup -identity $identitySource | Get-adgroupmember | Select Name -ExpandProperty Name
$Destinationgroupuser = Get-adgroup -identity $identityDestination | Get-adgroupmember

#AdSource the users to the Destination group 
function addgroupuser
{
    foreach ($item in $Sourcegroupuser) {
	Add-ADGroupMember -identity $identityDestination -members $item -Confirm:$false
    echo "It worked to add the member to the group"
   }
}

#Create the removeADGroupMembership function to remove the groups of users in the Destinationgroup after the move
function removeadgroupuser
{
     foreach ($user in $Destinationgroupuser) {
      if($user.objectClass -eq "user"){
         Get-adgroup -identity $identitySource | Remove-ADGroupMember -members $user -confirm:$false
       }
     }
    Write-host "The foreach loop has been succesfully completed."
}

#Checking the count of recorSource
Write-Host "Currently there are $($Sourcegroupuser.count) recorSource in the Source group and $($Destinationgroupuser.count) recorSource in the Destination group "
#Starting function to add users to the new (Destination) group
addgroupuser

#Starting function to remove the existing Destination group users in the Source group
removeadgroupuser

Write-host "The total recorSource have been modified to $($Sourcegroupuser.count) recorSource for the Source group and $($Destinationgroupuser.count) recorSource for the Destination group"
Write-host "The script has succesfully been completed."

