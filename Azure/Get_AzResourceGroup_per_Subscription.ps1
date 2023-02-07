#Checks what you want to check for?
function whatdoyouwant{
	$whatdoyouwant = Read-host -Prompt "If you would like to solely check resource groups type 1, for storage accounts specifically type 2"
	if($whatdoyouwant.length -lt 3){
		return $whatdoyouwant
	}
}

#Checks and loops through all subscriptions
function subscriptioninfo($functiontoexecute){
#Get all Azure subscriptions
$Subscriptions = Get-AzSubscription | Select-Object Id -ExpandProperty Id

if($functiontoexecute -like 'getresourcegroup'){
	#Foreach loop to go over the functions
	foreach ($Subscription in $Subscriptions){
		#Setting the subscription Context
		Set-AzContext -Subscription $Subscription
		getresourcegroup
	}
}
else{
	foreach ($Subscription in $Subscriptions){
	#Setting the subscription Context
	Set-AzContext -Subscription $Subscription
	$RGList = getresourcegroup
	$RGNameIn = $RGList | Select-Object ResourceGroupName -ExpandProperty ResourceGroupName   
	getstorageaccounts
}
else{
	write-host "Something went wrong"
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


function getstorageaccounts($RGNameIn){
	write-host "Now also checking storage accounts"
	foreach($name in $RGNameIn){
		Get-AzStorageAccount -ResourceGroupName $name
	}
}


$wdyw = whatdoyouwant
if($wdyw -like '1'){
	Write-Host "This function will now commense"
	$functiontoexecute = getresourcegroup
}
if($wdyw -like '2'){
	Write-Host "This function will now commense"
	$functiontoexecute = getstorageaccounts
}
