<#
Hi Guys, I made a small script for listing Sentinel alert rules per resource group
You can use it freely, wherever necessary. 

From the azure portal ìn the right top you have a way to click on the Powershell icon (cloudshell) and press powershell. From here you could run the script below directly

[LOCAL Run] PLEASE NOTE: IF MODULES HAVE TO BE INSTALLED: Run as Administrator
#>
#Install Required Modules
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
#Export Function
function exportfunction {
    #Just to double check that you would like to export information
    $export = Read-host -Prompt "Would you like to export the information [y/n]?"
    if ($export -eq 'y') {
        return $export
        continue
    }
}
function extendeddetails {
    #Just to double check that you would like to see extended details.
    #Default set is y. if you change the value you will see basic details
    $extended = "y"
    if ($extended.length -lt 1) {
        $extended = Read-Host -Prompt "Would you like to see extended information regarding the alert rules?"
    }
    if ($extended -eq 'y' -or $extended -eq 'yes') {
        return $extended
        continue
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
        $filename = "Alert_Rule_List_$date.csv"
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

#Function to get the Alert Rules per workspace
function GetAlertRules {
    #Get all workspaces
    foreach ($FoundResource in GetWorkspace) {
        $FoundResourceRGName = "$($FoundResource.ResourceGroupName)"
        $FoundResourceWorkspace = "$($FoundResource.ResourceName)"
        $WorkspaceAlertRuleList = Get-AzSentinelAlertRule -ResourceGroupName $FoundResourceRGName -WorkspaceName $FoundResourceWorkspace -ErrorAction Ignore
        if (extendeddetails) {
            foreach ($rule in $WorkspaceAlertRuleList) {
                #Basic overview of information inside the AlertRules
                New-Object -TypeName PSObject -Property @{
                    'ResourceGroupName'      = $FoundResourceRGName
                    'WorkspaceName'          = $FoundResourceWorkspace
                    'Kind'                   = $rule.Kind
                    'AlertDisplayName'       = $rule.AlertDisplayName
                    'Description'            = $rule.Description
                    'Status'                 = $rule.Status
                    'AlertFriendlyName'      = $rule.FriendlyName
                    'ProductName'            = $rule.ProductName
                }
            }
        }
        else {
            foreach ($rule in $WorkspaceAlertRuleList) {
                #Basic overview of information inside the AlertRules
                New-Object -TypeName PSObject -Property @{
                    'ResourceGroupName' = $FoundResourceRGName
                    'WorkspaceName'     = $FoundResourceWorkspace
                    'AlertDisplayName'  = $rule.AlertDisplayName
                    'Kind'              = $rule.Kind
                    'Status'            = $rule.Status
                }
            }
        }
    }
}
function localcall {
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
}
function domagic {
    if (localcall -and exportfunction) {
        <#
        Either this will do the trick or you have to change out the GetAlertRules parameter in front of the exports by setting a variable to hold the value and referring to this
        Like:
        $AlertRulelist = GetAlertRules
        $AlertRulelist | Out-File -FilePath $exportpath -NoClobber -NoOverwrite -Force
        #>
        $exportpath = exportpreperation
        GetAlertRules | Out-File -FilePath $exportpath -NoClobber -NoOverwrite -Force
    }
    if (localcall -and !(exportfunction)) {
        return GetAlertRules | Out-GridView
    }
    else {
        return GetAlertRules
    }
    
}
try {
    domagic
}
catch {
    Write-Error "An error has ocurred $($Error[0])"
}