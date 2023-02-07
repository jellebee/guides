#Checks what you want to check for?
function whatdoyouwant{
	$whatdoyouwant = Read-host -Prompt "If you would like to solely check resource groups type 1, for storage accounts specifically type 2"
	if($whatdoyouwant.length -lt 3){
		return $whatdoyouwant
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


$wdyw = whatdoyouwant
if($wdyw -like '1'){
	Write-Host "This function will now commense 1"
	$functiontoexecute = "getresourcegroup"
	$list = magiccrossubformula
	$list
}
if($wdyw -like '2'){
	Write-Host "This function will now commense 2"
	$functiontoexecute = "getstorageaccounts"
	$list = magiccrossubformula
	$list
}
