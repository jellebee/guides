#Checks what you want to check for?
function whatdoyouwant{
	$whatdoyouwant = Read-host -Prompt "If you would like to solely check resource groups type 1, for storage accounts specifically type 2"
	if($whatdoyouwant.length -lt 3){
		return $whatdoyouwant
	}
}

#Setting the local check
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

function installimportrequiredmodules {
    try {
        #Setting thr required modules list
        $ModulesToInstall = @("Az", "AzureADPreview")
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

#Create export function
function exportfunction {
    #Just to double check that you would like to export information
    $export = Read-host -Prompt "Would you like to export the information [y/n]?"
    if ($export -eq 'y') {
        return $export
        continue
    }
}

#Function for export config
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
        $filename = "Export_$($functiontoexport)_$($date).csv"
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


#Checks and loops through all subscriptions
function magiccrossubformula{
#Get all Azure subscriptions
$Subscriptions = Get-AzSubscription | Select-Object Id -ExpandProperty Id
write-host "I have to execute $($functiontoexecute)"
if($functiontoexecute -like "getresourcegroup"){
	#Foreach loop to go over the functions
	foreach ($Subscription in $Subscriptions){
		#Setting the subscription Context
		Set-AzContext -Subscription $Subscription
		getresourcegroup
	}
}
if($functiontoexecute -like "getstorageaccounts"){
	foreach ($Subscription in $Subscriptions){
	#Setting the subscription Context
	Set-AzContext -Subscription $Subscription
	$RGList = getresourcegroup
	$RGNameIn = $RGList | Select-Object ResourceGroupName -ExpandProperty ResourceGroupName   
	getstorageaccounts
}
}
}

function getresourcegroup {
	#Get all Resource Groups
	$getrg = Get-AzResourceGroup
	foreach($rg in $getrg){
		#Basic overview of information regarding resources
		New-Object -TypeName PSObject -Property @{
			'SubscriptionId'         = $Subscription
			'ResourceGroupName'      = $rg.ResourceGroupName
			'Location'		         = $rg.Location
			'ProvisioningState'		 = $rg.ProvisioningState
			'Tags'		             = $rg.Tags
			'ResourceId'             = $rg.ResourceId
		}
	}
}


function getstorageaccounts{
	write-host "Now also checking storage accounts"
	foreach($name in $RGNameIn){
		$SelectStorageAcc = Get-AzStorageAccount -ResourceGroupName $name | Select-Object *
		foreach ($account in $SelectStorageAcc){
			#Basic overview of information regarding a specific storage account
			New-Object -TypeName PSObject -Property @{
				'SubscriptionId'         = $Subscription
				'ResourceGroupName'      = $Name
				'StorageAccountId'       = $account.Id
				'StorageAccountName'     = $account.StorageAccountName
				'Location'		         = $account.Location
				'Kind'					 = $account.Kind
				'SkuName'				 = $account.Sku.Name
				'AccessTier'			 = $account.AccessTier
				'CreationTime'			 = $account.CreationTime
				'MinimumTlsVersion'		 = $account.MinimumTlsVersion
				'ProvisioningState'		 = $account.ProvisioningState
				'StatusOfSecondary'		 = $account.StatusOfSecondary
				'Tags'		             = $account.Tags
			}
		}
	}
}
function localandexportcheck {
	$localcall = localcall
	$exportfuntion = exportfunction
    if ($localcall -and $exportfuntion) {
        $exportpath = exportpreperation
        magiccrossubformula | Out-File -FilePath $exportpath -NoClobber -NoOverwrite -Force
    }
    if ($localcall -and !($exportfunction)) {
        return magiccrossubformula | Out-GridView
    }
    else {
        return magiccrossubformula
    }
}


$wdyw = whatdoyouwant
if($wdyw -like '1'){
	Write-Host "This function will now commense the RG checks"
	$functiontoexecute = "getresourcegroup"
	localandexportcheck
}
if($wdyw -like '2'){
	Write-Host "This function will now commense the StorageAccount checks"
	$functiontoexecute = "getstorageaccounts"
	localandexportcheck
}
