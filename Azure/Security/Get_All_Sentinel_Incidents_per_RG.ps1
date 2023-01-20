<#
Hi Guys, I made a small script for listing Sentinel incidents per resource group
You can use it freely, wherever necessary. 

From the azure portal ìn the right top you have a way to click on the Powershell icon (cloudshell) and press powershell. From here you could run the script below directly

[LOCAL Run] PLEASE NOTE: IF MODULES HAVE TO BE INSTALLED: Run as Administrator
#>
#Confirmation Function
function installimportrequiredmodules {
    try {
        #Setting thr required modules list
        $ModulesToInstall = @("Az", "Az.SecurityInsights")
        #Azure module required for connecting to Azure and installing the module required for Sentinel
        foreach ($module in $ModulesToInstall) {
            Install-Module -Name $module
            Import-Module -Name $module
        }
    }
    catch {
        Write-Host "Module $($module) could not be installed because of: $($Error[0])"
    }
}
function areyousure {
    #Just to double check that you would like to continue
    $areyousure = Read-host -Prompt "Would you like to export the information [y/n]?"
    if ($areyousure -eq 'y') {
        return $areyousure
        continue
    }
}
#Function for exportconfig
function exportpreperation {
    #Setting export path
    $path = "C:\Temp"
    #If the path is not set request the user for setting the path
    if ($path.length -lt 2) {
        $path = Read-Host -Prompt "What would you like the export path to be?"
    }
    #checking the directory exists and creating one where necessary
    If (!(test-path $path)) {
        New-Item -ItemType Directory -Force -Path $path
        Write-Host "A new export directory has been created at: $($path)"
    }

    $date = get-date -Format yyyyMMdd-HHmmss

    #Setting file name
    $filename = "IncidentList_$date.csv"
    if ($filename.length -lt 5) {
        $filename = Read-Host -Prompt "What would you like the (export) filename to be?"
    }
    $file = "$($path)\$($filename)"
    #Write-Host "The export filename has been set to $($filename)"
    return $file
}

#Function for obtaining all RG groups and within them every workspace
function GetWorkspace {
    #Setting the resource property. In this case I will filter by ResourceType
    $ResourceProperty = "ResourceType"
    #The filter value for the where clause, in this case what ResourceType
    $ResourcePropertyValue = "*/workspaces"
    #Obtain a list of all workspaces
    $ResourceList = Get-AzResource -ResourceGroupName * | Where-Object -Property $ResourceProperty -Like -Value $ResourcePropertyValue | Select-Object *
    return $ResourceList  
}

#Function to get the incidents per workspace
function GetIncidents {
    #Get all workspaces
    foreach ($FoundResource in GetWorkspace) {
        $FoundResourceRGName = "$($FoundResource.ResourceGroupName)"
        $FoundResourceWorkspace = "$($FoundResource.ResourceName)"
        $WorkspaceIncidentList = Get-AzSentinelIncident -ResourceGroupName $FoundResourceRGName -WorkspaceName $FoundResourceWorkspace -ErrorAction Ignore
        foreach ($incident in $WorkspaceIncidentList) {
            #Basic overview of information inside the incidents
            New-Object -TypeName PSObject -Property @{
                'ResourceGroupName'      = $FoundResourceRGName
                'WorkspaceName'          = $FoundResourceWorkspace
                'ProviderName'           = $incident.Providername
                'ProviderIncidentNumber' = $incident.ProviderIncidentId
                'IncidentID'             = $incident.Name
                'Title'                  = $incident.Title
                'Description'            = $incident.Description
                'Severity'               = $incident.Severity
                'Label'                  = $incident.Status
                'CreateDate'             = $incident.CreatedTimeUtc
                'URL'                    = $incident.Url
            }
        }
    }
}

$local = Read-Host -Prompt "Are you running the script locally? Say 'yes' or 'y' elsewise AZ connection will not be established."
if ($local -eq "yes" -or $local -eq "y") {
    try {
        #Before doing anything, install the required modules (this also allows an automatic import)
        installimportrequiredmodules
        $succes = $true
    }
    catch {
        Write-Host "You probably did not install the module. Please use the Install-Module cmdlet or checkout the Install_AZ_Module_and_Connect script in GitHub"
    }
    if ($succes -eq $true) {
        Connect-AzAccount
    }
}

<#
Either this will do the trick or you have to change out the GetIncidents parameter in front of the exports by setting a variable to hold the value and referring to this
Like:
$incidentlist = GetIncidents
$incidentlist | Out-File -FilePath $exportpath -NoClobber -NoOverwrite -Force
#>
if (areyousure -eq 'y' -and $local -eq 'y' -or $local -eq 'yes') {
    $exportpath = exportpreperation
    GetIncidents | Out-File -FilePath $exportpath -NoClobber -NoOverwrite -Force
}
elseif (areyousure -ne 'y' -and $local -eq 'y' -or $local -eq 'yes') {
    GetIncidents | Out-GridView
}
else {
    GetIncidents
}