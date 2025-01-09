<#
Automate the closing of resolved/done devops items
First Steps:
Set the org name in the $org, the project name in $project and the apiversion in $apiVer
Now set the $personalAccessToken or PAT in code if you copy and run it or set it in a script via parsing through pipeline or add Read-Host to prompt for user input
You can also add a $startDate from which you want to automatically finish up on/remove the tasks going forward. For now leave it at the default of 01-01-2021
#>

$project = "myProject" #to be replaced
$org = "myOrg" #to be replaced
$orgUrl = "https://dev.azure.com/$org"
$apiVer = "7.1"
$personalAccessToken = ""

# Base64 encode the personal access token
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))


#Room for functions
function Get-UserStoriesList {
	param(
		[string]$startDate="01-01-2021"
	)
	#Functional URL's
	$workItemQueryUrl = "$orgUrl/$project/_apis/wit/wiql?api-version=$apiVer"

    # Define the WIQL query with pagination
	#Add in the start date of the search.. 2021
    $query = @{
        query = "SELECT [System.Id], [System.Title], [System.State] FROM WorkItems WHERE [System.TeamProject] = '$project' AND [System.WorkItemType] = 'User Story'"
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri $workItemQueryUrl -Method Post -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Body $query -ContentType "application/json"
    $workItems = $response.workItems
    
    return $workItems
}
function Get-SpecificWorkItemDependencies {
	param (
		[string]$workItemId,
		[bool]$isStory=$false
	)
	#Functional URL's
	$workItemQueryUrl = "$orgUrl/$project/_apis/wit/workitems/$($workItemId)?api-version=$apiVer"
	
	$response = Invoke-RestMethod -Uri $workItemQueryUrl -Method get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Body $query -ContentType "application/json"
	if($isStory){
		if ($response.fields."System.State" -in ("Resolved","Removed","Done")) {
			return $response
		}
	}
	else{
		return $response
	}
}
function Check-UnderlyingChildRelations {
	param (
		[string]$workItemId,
		[string]$Base64AuthInfo
	)
	# Functional URL's
	$workItemLinksUrl = "$orgUrl/$project/_apis/wit/wiql?api-version=$apiVer"
	# Initialize function parameter
	$childrensIdList = @()
	$wiqlQuery = @{
		query = "SELECT [System.Id], [System.Title], [System.State] 
				 FROM WorkItemLinks 
				 WHERE [Source].[System.Id] = $workItemId 
				 AND [System.Links.LinkType] = 'Child'
				 AND [Target].[System.WorkItemType] = 'Task'
				 ORDER BY [System.Id]"
	} | ConvertTo-Json
	$response = Invoke-RestMethod -Uri $workItemLinksUrl -Method Post -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo)} -Body $wiqlQuery -ContentType "application/json"
	$children = $response.workItemRelations | Where-Object { $_.rel -eq 'System.LinkTypes.Hierarchy-Forward' }
	foreach ($childId in $children.target.id) {
		$taskStatus = (Get-SpecificWorkItemDependencies -workItemId $childId -Base64AuthInfo $Base64AuthInfo).fields."System.State"
		if ($taskStatus) {
			$childrensIdList += $childId
		}
	}
	return $childrensIdList
}
function Update-TaskStatus {
	param (
		[string]$taskId,
		[string]$newStatus
	)
	if ("$(workItemCloserDryRun)" -eq "no") {
		# Azure DevOps organization and project-specific URL
		$apiUrl = "$orgUrl/_apis/wit/workitems/$($taskId)?api-version=$apiVer"

		$jsonPayload = '[{ "op": "add", "path": "/fields/System.State", "value": "' + $newStatus + '" }]'

		$response = Invoke-RestMethod -Uri $apiUrl -Method Patch -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo)} -Body $jsonPayload -ContentType "application/json-patch+json"
		if ($response) {
			Write-Output "Task ID: $taskId status updated to $newStatus."
		}
	} else {
		Write-Host "This is just a dry run. If it was not, the following would happen: `nTask ID: $taskId will be updated to $newStatus"
	}
}

#Default capture all tasks in project vars
$allUserStories = Get-UserStoriesList -startDate "01-01-2021"
foreach($userStory in $allUserStories.Id){
	$getUserStoryStatus = (Get-SpecificWorkItemDependencies -workItemId $userStory -isStory $true -Base64AuthInfo $Base64AuthInfo).fields."System.State"
	if (!$getUserStoryStatus) { continue } # if the user story is not found, skip to the next one

	$underLyingChildren = Check-UnderlyingChildRelations -workItemId $userStory -Base64AuthInfo $Base64AuthInfo
	if (!$underLyingChildren) { continue } # if the user story has no children, skip to the next one

	foreach ($child in $underLyingChildren) {
		$listChildTaskDependencyStatus = (Get-SpecificWorkItemDependencies -workItemId $child -Base64AuthInfo $Base64AuthInfo).fields."System.State"
		if ($getUserStoryStatus -ne $listChildTaskDependencyStatus -and $listChildTaskDependencyStatus -notin ("Done", "Removed", "Closed")) {
			if ($getUserStoryStatus -in ("Done", "Resolved")) {
				Write-Host "Updating the task $($child) status to Done since the PBI $userStory is of status $getUserStoryStatus"
				Update-TaskStatus -taskId $child -newStatus "Done" -Base64AuthInfo $Base64AuthInfo
			} elseif ($getUserStoryStatus -eq "Removed") {
				Write-Host "Updating the task $($child) status to Removed since the PBI $userStory is of status $getUserStoryStatus"
				Update-TaskStatus -taskId $child -newStatus "Removed" -Base64AuthInfo $Base64AuthInfo
			}
		}
	}
}