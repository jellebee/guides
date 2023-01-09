Write-Host "Welcome to Get_User_Group_Membership. The best script to get the membership of an AD user!`n `
If you have multiple accounts like account_1 and account_2 please just enter account_ as it automatically finds anything mathing the content written here
"
#Sets date format in year month day hours minutes seconds
$date = Get-Date -Format yyyyMMdd:HHmmss

#Sets export path
$exportpath = "C:\temp\Get_User_Group_Membership_$($date).csv"

#Asks the user to enter a name
$GetADUser = Read-Host -prompt "Please enter the full or part of the name of the user(s) to continue."
if($GetADUser -ne $null -and $GetADUser.Length -gt 1){
	$ADUser = Get-ADUser -Filter 'Name -like "*$($GetADUser)*"' | select Name -ExpandProperty Name
}
else{
	#You could replace below with a break to break the script instead if you prefer.
	Write-Host "The script will not continue due the fact that no name has been entered"
	pause
}

#Sets output variable with the content
$output = foreach($user in $ADUser){
$Groupmember = Get-AdPrincipalGroupMembership -identity $User | where {$_.Name -ne “Domain Users”} | Select-Object Name -ExpandProperty Name
[pscustomobject] @{
Username = $user
Groupnames = $Groupmember
} | Select-Object Username,Groupnames

}
$output | Out-File $exportpath