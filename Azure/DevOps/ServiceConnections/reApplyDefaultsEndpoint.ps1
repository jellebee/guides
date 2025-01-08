<#
This piece of code updates all service endpoint connections with some where clauses for filtering.
Idea is we could update current connections to "old" if we already created new service endpoint connections.
So we could fall back at the previous service connection incase the new one does not perform as expected in our pipelines (e.g. missing permissions)

First Steps:
Login at the Azure and Azure DevOps CLI, See below
az login needed for entra id access
az devops cli login needed by using PAT see example below
echo "MYPAT" | az devops login --organization $orgUrl
Set the org name in the $orgUrl, the project name in $project and the apiversion in $apiVer
(optional) Set the SPNName in $mySpn and the authSchemeName in $authSchemeName
Configuratie details #>
$project = "myProject" #replaceMe
$org = "myOrg" #replaceMe
$orgUrl = "https://dev.azure.com/$org"
$apiVer = "7.1"
$mySpn = "44231d-wdwiaf3-3291-21840"
$authSchemeName = "WorkloadIdentityFederation"

#Get project info
$projectInfo = az devops project show --project $project --organization $orgUrl | ConvertFrom-Json
$projectId = $projectInfo.id

Get all service endpoints
$serviceConnectionsJson = az devops service-endpoint list --project $project --organization $orgUrl | ConvertFrom-Json

# Filter the service connection by your SPN and NOT the type set in the authSchemeName parameter
$cloudConnectionList = $serviceConnectionsJson | Sort-Object -Property Name | Where-Object {$_.authorization.scheme -ne $authSchemeName -and $_.authorization.parameters.serviceprincipalid -eq $mySpn }

#Be aware the LIMIT for the amount of workload federations is 20 per app reg.
foreach ($connection in $cloudConnectionList) {
    #SERVICECONNECTIONS
    #Update old service connection to be named old (for ones using a service principal)
    # Build the REST API URL
    $apiUrl = "$orgUrl/$project/_apis/serviceendpoint/endpoints/$($connection.id)?api-version=$apiVer"

    # Prepare the updated payload
    $updatedPayload = @{
        data = $connection.data
        id = $connection.id
        name = "$($name)-OLD"
        type = $connection.type
        url = $connection.url
        description = $connection.description
        authorization = @{
            scheme = $connection.authorization.scheme
            parameters = @{
                serviceprincipalid = $spId
                tenantid = $tenantId
                serviceprincipalkey = "REPLACEME" #fill the key here.. This could be a default
            }
        }
        isShared = $connection.isShared
        isReady = $connection.isReady
        owner = $connection.owner
        serviceEndpointProjectReferences = @(
            @{
                projectReference = @{
                    id = $projectId
                    name = $projectName
                }
                name = "$($name)-OLD"
            }
        )
    } | ConvertTo-Json -Depth 10 -Compress

    # Make the REST API call to update the service endpoint
    $response = Invoke-RestMethod -Uri $apiUrl -Method Put -Headers @{
        Authorization = "Bearer $pat"
        "Content-Type" = "application/json"
    } -Body $updatedPayload
    if ($response) {
        Write-Host "Service endpoint renamed from '$name' to '$($name)-OLD'."
    } else {
        Write-Error "Failed to rename the service endpoint."
    }
}