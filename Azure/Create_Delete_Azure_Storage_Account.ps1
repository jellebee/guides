#This script can be used to create or delete an Azure storage account
#Set the option as a default (Create/Delete)
$createdelete = ""

#If no option is given this if loop will request the user what he/she would like to do
if ($createdelete -ne 1 -or $createdelete -ne 2) {
    $createdelete = Read-Host -Prompt "Would you like to create or delete an Azure Storage Account? [Select 1 for create and 2 for delete]"
}

#If no resourcegroup is set, request the user which one to select (Manual input)
$resourcegroupname = ""
if ($resourcegroupname.Length -lt 2) {
    $resourcegroupname = Read-Host -Prompt "Which Resource group would you like to select?"
}
$accountname = ""
if ($accountname.Length -lt 2) {
    $accountname = Read-Host -Prompt "Which name would you like to select for your storage account?"
    if ($accountname -eq "") {
        $accountname = "$($resourcegroupname)-Storage-Account"
        Write-Host "As you have not selected any account, the storage account will be named $($resourcegroupname)-Storage-Account"
    }
    Write-Host "Your account will be named $($accountname))"
}

#Confirmation function
function areyousure {
    #Just to double check that you would like to continue
    $areyousure = Read-host -Prompt "Are you sure you would like to continue? [y/n]"
    if ($areyousure -eq 'y') {
        return $areyousure
        continue
    }
    else {
        break
    }
}

#Create function
function createstorageaccount {
    #Setting location information
    $location = ""
    if ($location.Length -lt 2) {
        $location = Read-Host -Prompt "Which name would you like to select for your storage account?"
        if ($location -eq "") {
            $location = ""
        }
        Write-Host "Your location is set to be $($location)"
    }
    #Configuring SKU and Kind
    $skuname = "Standard_RAGRS"
    $kind = "StorageV2"
    #Performing all magic
    if (areyousure -eq 'y') {
        New-AzStorageAccount -ResourceGroupName $resourcegroupname `
            -Name $accountname `
            -Location $location `
            -SkuName $skuname `
            -Kind $kind
    }
}
#Delete function
function deletestorageaccount {
    if (areyousure -eq 'y') {
        Remove-AzStorageAccount -Name $accountname -ResourceGroupName $resourcegroupname
    }
}
if ($createdelete -eq 1) {
    try {
        createstorageaccount
    }
    catch {
        Write-Host "An error has ocurred $($Error[0])"
    }
}
elseif ($createdelete -eq 2) {
    try {
        deletestorageaccount
    }
    catch {
        Write-Host "An error has ocurred $($Error[0])"
    }
}
else {
    Write-host "You did not select a valid option"
}