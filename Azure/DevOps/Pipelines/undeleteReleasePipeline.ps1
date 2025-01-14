param (
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string] $token, #Replace this with your 
[ValidateNotNullOrEmpty()]
[string] $definitionNameToRecover = "deploy agents release", #Replace this with your releaseDefinitionName, or call the script providing this
[ValidateNotNullOrEmpty()]
[string] $projectName = "team IT-Admin", #sets default project, Replace this with your projectName
[ValidateNotNullOrEmpty()]
[string] $orgName = "myOrg" #sets default org, Replace this with your org

)
## Construct a basic auth head using PAT
function BasicAuthHeader()
{
param([string]$authtoken)
$ba = (":{0}" -f $authtoken)
$ba = [System.Text.Encoding]::UTF8.GetBytes($ba)
$ba = [System.Convert]::ToBase64String($ba)
$h = @{Authorization=("Basic{0}" -f $ba);ContentType="application/json"}
return $h
}
$apiVer = "7.1"

# Find the Id of release definition that got deleted
$deletedReleaseDefinitionsUri = "https://$orgName.vsrm.visualstudio.com/$projectName/_apis/Release/definitions?api-version=$apiVer&isDeleted=true&searchText=$definitionNameToRecover"
$h = BasicAuthHeader $token
$deletedDefinitions = Invoke-RestMethod -Uri $deletedReleaseDefinitionsUri -Headers $h -ContentType “application/json" -Method Get
$deletedDefinitionJSON = $deletedDefinitions | ConvertTo-Json -Depth 100
write-host "Found the deleted definitions : $deletedDefinitions"
$deletedReleaseDefinitionId = $deletedDefinitions.Value[0].id
write-host "Found the deleted id : $deletedReleaseDefinitionId "

# Recover the deleted release definition
$undeleteReason = '{ "Comment" : "Deleted by mistake" }'
$undeleteReleaseDefinitionUri = "https://$orgName.vsrm.visualstudio.com/$projectName/_apis/Release/definitions/$deletedReleaseDefinitionId`?api-version=$apiVer"
$undeletedDefinition = Invoke-RestMethod -Uri $undeleteReleaseDefinitionUri -Headers $h -ContentType “application/json" -Method Patch -Body $undeleteReason
$name = $undeletedDefinition.name
write-host "$name recovered successfully"