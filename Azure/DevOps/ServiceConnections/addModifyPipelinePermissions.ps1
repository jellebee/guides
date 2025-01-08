<#
First Steps:
Login at the Azure and Azure DevOps CLI, See below
az login needed for entra id access
az devops cli login needed by using PAT see example below
echo "MYPAT" | az devops login --organization $orgUrl
Set the org name in the $org, the project name in $project and the apiversion in $apiVer
Also set the SPNName in $mySpn and the authSchemeName in $authSchemeName
Please be aware that you should set to authSchemeName to whatever your agents use, or you might adjust things in the wrong way!
Configuratie details #>
$project = "projname" #replaceMe
$org = "orgname" #replaceMe
$orgUrl = "https://dev.azure.com/$org"
$apiVer = "7.1"
$mySpn = "44231d-wdwiaf3-3291-21840"
$authSchemeName = "WorkloadIdentityFederation"

# Get all service endpoints
$serviceConnectionsJson = az devops service-endpoint list --project $project --organization $orgUrl | ConvertFrom-Json

# Filter de service connection "mySpn" You could remove this to just get a list of all workloadIdentityFederations in the script.
# Then again that could also be adjusted.
$cloudConnectionList = $serviceConnectionsJson | Sort-Object -Property Name | Where-Object {$_.authorization.scheme -eq $authSchemeName -and $_.authorization.parameters.serviceprincipalid -eq $mySpn }

foreach ($connection in $cloudConnectionList) {
    <#
    2. Grant Permission to All Pipelines through the for each
    This can also be used to set specific permissions.
    Check the pipelines/pipelinePermissions/ graph api documentation
    https://learn.microsoft.com/en-us/rest/api/azure/devops/approvalsandchecks/pipeline-permissions/update-pipeline-permisions-for-resources?view=azure-devops-rest-7.1 
    #>
    $grantPermissionUri = "$orgUrl/$project/_apis/pipelines/pipelinePermissions/endpoint/$($connection.id)?api-version=$apiVer-preview"
    # Laad de JSON-sjabloon en maak wijzigingen
    $credentialTemplate = Get-Content -Path "patch.json" | Out-String
    $patchPipelineJson = $credentialTemplate -replace "{endpointId}", $connection.id

    $permissionResponse = Invoke-RestMethod -Uri $grantPermissionUri -Method Patch -Headers @{
        Authorization = "Bearer $pat"
        "Content-Type" = "application/json"
    } -Body $patchPipelineJson

    if ($permissionResponse -gt $null) {
        Write-Host "Permissions granted successfully."
    } else {
        Write-Host "Failed to grant permissions."
    }
}