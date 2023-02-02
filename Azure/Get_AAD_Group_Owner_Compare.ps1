#Connect To azureAD
Connect-AzureAD
#Set a list of groups
$Grouplist = Get-AzureADGroup -Top 10000 | select *
#Set cloudops group
$cloudopsgroup = Get-AzADGroup -SearchString "AdminTeam"
$cloudopsgroupowner = Get-AzureADGroupOwner -ObjectId $cloudopsgroup.id
#Set group list
$output = foreach($group in $Grouplist){
    $groupusers = Get-AzureADGroupOwner -ObjectId $group.objectid
    foreach($user in $groupusers){
        if ($user.UserPrincipalName -in ($cloudopsgroupowner.UserPrincipalName)){
            ($group.DisplayName)
        }
    }
}
$output | Select-Object -Unique | Sort-Object