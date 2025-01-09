<#
Build for converting connections from the current service principal authentication (manual) to workload federation (manual)
This code only adds new connections. It does not replace old ones.
This will target only 1 connection at a time, trying more would result in having multiple connections with similar names, please use wisely.

First Steps:
Login at the Azure and Azure DevOps CLI, See below
az login needed for entra id access
az devops cli login needed by using PAT see example below
echo "MYPAT" | az devops login --organization $orgUrl
Set the org name in the $orgUrl and the project name in $project
(optional) Set the SPNName in $mySpn and the authSchemeName in $authSchemeNam
(required) Set the $yourNewServiceConnection based on what you would like the name to be
(required) Set the $federationIssuer from the specified app registration
Configuratie details #>
$project = "projname"
$org = "myorg"
$orgUrl = "https://dev.azure.com/$org"
$mySpn = "44231d-wdwiaf3-3291-21840"
$yourNewServiceConnection="fillOutYourConnectionHere"
$federationIssuer = "https://vstoken.dev.azure.com/2d93526-d828-ae21-a183-f46fee5ca1c6"

#echo "MYPAT" | az devops login --organization $orgUrl #Used for signing into the Azure DevOps CLI

# Get all service endpoints
$serviceConnectionsJson = az devops service-endpoint list --project $project --organization $orgUrl | ConvertFrom-Json

# Set the "myConnection" below to anything useful to target specific connections. Elsewise remove the where clause
$serviceEndpointConnections = $serviceConnectionsJson | Where-Object { $_.name -eq "myConnection" }

#uses the SPN currently used for creating new service connections based on workload federation.
if ($serviceEndpointConnections.authorization.parameters.serviceprincipalid -eq $mySpn) {
    #PREPERATIONS
    $spId = $serviceEndpointConnections.authorization.parameters.serviceprincipalid
    $newName = $yourNewServiceConnection
    $tenantId = $serviceEndpointConnections.authorization.parameters.tenantid
    $subscriptionId = "" # PLEASE ADD YOUR SUBSCRIPTION ID HERE
    $subscriptionName = yourNewServiceConnection #Names of subscriptions are always identical to the service connection name
    
    #APPREG Permissions
    # Laad de JSON-sjabloon en maak wijzigingen
    $credentialTemplate = Get-Content -Path "credential.template.json" | Out-String
    $credentialJson = $credentialTemplate -replace "{ServiceConnectionName}", $newName
    $credentialJson = $credentialTemplate -replace "{FederationIssuer}", $federationIssuer
    $credentialJson = $credentialTemplate -replace "{ProjectName}", $project
    $credentialJson = $credentialTemplate -replace "{OrgName}", $org

    # Schrijf het bijgewerkte JSON naar een tijdelijk bestand
    $tempFilePath = "credential.json"
    $credentialJson | Set-Content -Path $tempFilePath

    # Voeg federatieve credentials toe aan de service principal
    az ad app federated-credential create --id $spId --parameters @$tempFilePath
    Write-Host "Federatie voor service principal $spId toegevoegd met bestandsnaam: ${newName}"

    #SERVICECONNECTIONS
    $templatePath = "serviceConnection.template.json"
    $serviceConnectionTemplate = Get-Content -Path $templatePath -Raw
    $serviceConnectionJson = $serviceConnectionTemplate `
        -replace "{Name}", $newName `
        -replace "{ServicePrincipalId}", $spId `
        -replace "{TenantId}", $tenantId `
        -replace "{SubscriptionId}", $subscriptionId `
        -replace "{SubscriptionName}", $subscriptionName
    
    # Schrijf het bijgewerkte JSON naar een tijdelijk bestand
    $serviceConfigFile = "serviceConnection.json"
    $serviceConnectionJson | Set-Content -Path $serviceConfigFile

    # Create a new service connection using Workload Identity Federation
    az devops service-endpoint create --service-endpoint-configuration $serviceConfigFile --project $project --organization $orgUrl
    Write-Host "Nieuwe service connectie $newName aangemaakt met Workload Identity Federation"

    # Remove temp files
    Remove-Item -Path $tempFilePath, $serviceConfigFile
}