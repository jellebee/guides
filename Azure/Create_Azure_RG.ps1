<#
Hi Guys, I made a small script for creating a RG from PS. I will also add an AZCLI file up later. 
You can use it freely, wherever necessary. 

From the azure portal ìn the right top you have a way to click on the Powershell icon (cloudshell) and press powershell. From here you could run the below directly
Please check the script for connecting to Azure and O365 which will be added later in GIT, as well as the VM creation
#>

function areyousure{
    #Just to double check that you would like to continue
    $areyousure = Read-host -Prompt "Are you sure you would like to continue? [y/n]"
    if($areyousure -eq 'y'){
        return $areyousure
        continue
    }
    else{
        break
    }
}
function createRG{
    try{
        #Create a new AzResourceGroup
        New-AzResourceGroup -Name $resource_group_name -Location $location
        Write-Host "The group $($resource_group_name) has been succesfully created!"
    }
    catch{
        Write-Host "An error has occurred. Please check the error listed $($Error[0])"
    }
}

#Question if you would like to make a new RG in Azure
$wantanRG = Read-Host -Prompt "Would you like to create an RG? [y/n]"
if($wantanRG -eq 'y'){
#Please fill in the desired username to be created.
#If left blank it will default to RG_Virtual_machine_test
$resource_group_name  = Read-Host -Prompt "What name would you like to set for your RG?"
if ($resource_group_name -eq $null){
    break
}

#Please enter the desired resource location
$rglocation = Read-Host -Prompt "What location would you like to set for your RG?"
if ($rglocation -eq $null -or $rglocation.Length -lt 3){
    $rglocation = "EastUS"
}

Write-Host "The name for your RG is $($resource_group_name) with location $rglocation `
We will now attempt to create the RG."

#Validates that the are you sure question is answered with y. Elsewise throwing an error
if (areyousure -eq 'y'){
    createRG
}
else {
    Write-Host "The drafted RG $($resource_group_name) with location $($rglocation) will not be created. Please run the script again if necessary."
}
}
