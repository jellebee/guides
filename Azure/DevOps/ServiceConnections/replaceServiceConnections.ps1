<#
Build for converting connections from the current service principal authentication (manual) to workload federation (manual)

First Steps:
Login at the Azure and Azure DevOps CLI, See below
az login needed for entra id access
az devops cli login needed by using PAT see example below
echo "MYPAT" | az devops login --organization $orgUrl
Set the org name in the $org, the project name in $project and the apiversion in $apiVer
(optional) Set the SPNName in $mySpn and the authSchemeName in $authSchemeName
(required) Set the federationIssuer from the specified app registration
Configuratie details #>
$project = "projname"
$org = "org"
$orgUrl = "https://dev.azure.com/$org"
$apiVer = "7.1"
$mySpn = "44231d-wdwiaf3-3291-21840"
$authSchemeName = "WorkloadIdentityFederation"
$federationIssuer = "https://vstoken.dev.azure.com/2d93526-d828-ae21-a183-f46fee5ca1c6"

#login to azure devops cli with your PAT, make sure the PAT has FULL access
#echo  "MyPat" | az devops login --organization $orgUrl

#If you want to use an exclusion list use this
$list = @("MY-SUBSC")

# Get all service endpoints
$serviceConnectionsJson = az devops service-endpoint list --project $project --organization $orgUrl | ConvertFrom-Json

# Filter the service connection
$cloudConnectionList = $serviceConnectionsJson | Sort-Object -Property Name | Where-Object {$_.name -notin $list -and $_.authorization.scheme -ne $authSchemeName -and $_.authorization.parameters.serviceprincipalid -eq $mySpn }

#Be aware the LIMIT for the amount of workload federations is 20 per app reg.
foreach ($connection in $cloudConnectionList) {
    #PREPERATIONS
    $spId = $connection.authorization.parameters.serviceprincipalid
    $name = $connection.name
    $subscriptionId = $connection.data.subscriptionId
    
    #Incase this goes wrong you will need this to fix it
    Write-Host "Now starting with Service Connection: $name & Subscription ID: $subscriptionId"

    #APPREG Permissions
    # Laad de JSON-sjabloon en maak wijzigingen
    $credentialTemplate = Get-Content -Path "credential.template.json" | Out-String
    $credentialJson = $credentialTemplate -replace "{ServiceConnectionName}", $name
    $credentialJson = $credentialTemplate -replace "{FederationIssuer}", $federationIssuer
    $credentialJson = $credentialTemplate -replace "{ProjectName}", $project
    $credentialJson = $credentialTemplate -replace "{OrgName}", $org

    # Schrijf het bijgewerkte JSON naar een tijdelijk bestand
    $tempFilePath = "credential.json"
    $credentialJson | Set-Content -Path $tempFilePath

    # Voeg federatieve credentials toe aan de service principal
    az ad app federated-credential create --id $spId --parameters @$tempFilePath
    Write-Host "Federatie voor service principal $spId toegevoegd met bestandsnaam: ${name}"

    #SERVICECONNECTIONS
    # Modify Connection from ServicePrincipal to WorkloadIdentityFederation
    $connection.authorization.parameters.PSObject.Properties.Remove('authenticationType')
    $connection.authorization.parameters | Add-Member -MemberType NoteProperty -Name 'workloadIdentityFederationIssuer' -Value $federationIssuer
    $connection.authorization.parameters | Add-Member -MemberType NoteProperty -Name 'workloadIdentityFederationSubject' -Value "sc://$org/$project/$name"
    $connection.authorization.scheme = 'WorkloadIdentityFederation'
    $connection.isShared = $false

    $apiUrl = "$orgUrl/$project/_apis/serviceendpoint/endpoints/$($connection.id)?api-version=$apiVer"
    # Make the REST API call to update the service endpoint
    Invoke-RestMethod -Uri $apiUrl -Method Put -Headers @{
    Authorization = "Bearer $pat"
    "Content-Type" = "application/json"
    } -Body ($connection | convertTo-Json -Depth 100 -Compress)
}