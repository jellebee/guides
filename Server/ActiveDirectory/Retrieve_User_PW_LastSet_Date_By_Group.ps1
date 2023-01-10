#Requires the ActiveDirectory module to be present
Import-Module ActiveDirectory

#Enter the AD group name
$groupname = "Domain Users"
#Gets all users through the specified group. For retrieving all groups please leave it on "Domain Users" (unless you set a different default group, then alter it)
$usersingroup = get-adgroup $groupname | get-adgroupmember

#Loops through every user in the mentioned group and retrieves the date the pw was last set.
$userlist = foreach ($user in $usersingroup){
    get-aduser $user -properties * | Select-Object Name, PasswordLastSet | Where PasswordLastSet -LT (Get-Date).AddDays(-90)
}
#Writes output to console
Write-host "For the follwing users the password set is older than 90 days (3 months):"
$userlist
