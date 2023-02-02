function installimportrequiredmodules {
    try {
        #Setting th required modules list
        $ModulesToInstall = @("Az")
        #Azure module required for connecting to Azure
        foreach ($module in $ModulesToInstall) {
            Install-Module -Name $module -Force -AllowClobber
            Import-Module -Name $module
        }
    }
    catch {
        Write-Host "Module $($module) could not be installed because of: $($Error[0])"
    }
}

function exportfunction {
    #Just to double check that you would like to export information
    $export = Read-host -Prompt "Would you like to export the information [y/n]?"
    if ($export -eq 'y') {
        return $export
    }
}

#Function for exportconfig
function exportpreperation {
    try {
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
        $filename = "Resourcelist_$date.csv"
        if ($filename.length -lt 5) {
            $filename = Read-Host -Prompt "What would you like the (export) filename to be?"
        }
        $file = "$($path)\$($filename)"
        return $file
    }
    catch {
        Write-Error "I guess something went wrong in your export preperation"
        continue
    }
}

function getresourcebysubscription {
    #Get all Azure subscriptions
    $Subscriptions = Get-AzSubscription | Select-Object Id -ExpandProperty Id

    #Get the policies per subscription
    foreach($Subscription in $Subscriptions){
        #Get all azure policy states
        $policies = Get-AzPolicyState -SubscriptionId $Subscription | select *
        foreach($policy in $policies){
            #Basic overview of information regarding resources
            New-Object -TypeName PSObject -Property @{
                'SubscriptionId'         = $Subscription
                'ResourceGroup'          = $policy.ResourceGroup
                'ResourceType'           = $policy.ResourceType
                'ResourceLocation'       = $policy.ResourceLocation
                'CompliancyState'        = $policy.ComplianceState
            }
        }
    }
}


function domagic{
    #To connect to Azure login through here
    Connect-AzAccount
    #Setexportfunctioncheck
    $exportchoice = exportfunction
    if ($exportchoice){
        $exportpath = exportpreperation
        getresourcebysubscription | Out-File -FilePath $exportpath -NoClobber -NoOverwrite -Force
    }
    elseif(!($exportchoice)){
        getresourcebysubscription
    }
}

if(installimportrequiredmodules){
    domagic
}