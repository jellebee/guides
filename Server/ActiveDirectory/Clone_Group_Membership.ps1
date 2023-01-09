Import-Module activedirectory

$FromADAccount = "sourceuser" #CloneGroupMembership source user
$ToADAccount = "destinationuser" #CloneGroupMembership destination user

[array]$ADGroupMembership = $null
	$ADGroupMembership += Get-ADPrincipalGroupMembership $FromADAccount | Select @{`
		Name="Samaccountname";Expression={ (get-aduser $user).samaccountname }
		}`
		, distinguishedname
foreach ($item in $ADGroupMembership) {
	Add-ADGroupMember -id $item.distinguishedname -members $ToADAccount
}