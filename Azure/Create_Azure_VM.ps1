<#
Hi Guys, I made a small script for creating a VM from PS. I will also add an AZCLI file up later. 
You can use it freely, wherever necessary. 

From the azure portal ìn the right top you have a way to click on the Powershell icon (cloudshell) and press powershell. From here you could run the script below directly
Please check the script for connecting to Azure in the Azure GIT repo. O365 will be added later.
#>
$local = Read-Host -Prompt "Are you running the script locally? Say 'yes' or 'y' elsewise AZ connection will not be established."
if ($local -eq "yes" -or $local -eq "y")
{
	#Before doing anything, importing the module and connecting to Azure
	Import-Module -Name Az
	Connect-AzAccount
}

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
function createnewvm{
    try{
        New-AzVm `
        -ResourceGroupName $resource_group_name `
        -Name $vm_name`
        -Location $rglocation `
        -VirtualNetworkName $vnet_name `
        -SubnetName $subnet_name `
        -SecurityGroupName $nsg_name `
        -PublicIpAddressName $pubip_name `
        -OpenPorts $openports
        
        Write-Host "finished the creation of the VM $($vm_name) in RG $($resource_group_name)"
    }
    catch{
        Write-Host "An error has occurred. Please check the error listed $($Error[0])"
    }
}

$resource_group_name  = Read-Host -Prompt "What RG would you like to select?"
if ($resource_group_name -eq $null){
    break
}

#Please enter the desired resource location
$rglocation = Read-Host -Prompt "Where is your RG located (default EastUS)?"
if ($rglocation -eq $null -or $rglocation.Length -lt 3){
    $rglocation = "EastUS"
}
Write-Host "The selected RG is $($resource_group_name) with location $rglocation"

#Please enter the desired resource location
$vm_name = Read-Host -Prompt "What would you like your VM to be named like?"
$vnet_name = Read-Host -Prompt "What would you like your VNET name to be?"
if ($vm_name -eq $null -or $vnet_name -eq $null){
    break
}
$subnet_name = Read-Host -Prompt "What would you like your Subnet name to be? (If none is selected it will be called SubA_Priv)"
if ($subnet_name -eq $null -or $subnet_name.Length -lt 3){
    $subnet_name = "SubA_Priv"
}
$nsg_name = Read-Host -Prompt "What would you like your NSG name to be? (If none is selected it will be called NSG-VM-$($vm_name)"
if ($nsg_name -eq $null -or $nsg_name.Length -lt 3){
    $nsg_name = "NSG-VM-$($vm_name)"
}
$pubipcheck = Read-Host -Prompt "Would you like a PublicIP?"
if($pubipcheck -eq 'y'){
    $pubip_name = Read-Host -Prompt "What would you like your PublicIP name to be? (if none is selected it will default to PUB-IP-$($vm_name))"
    if ($pubip_name -eq $null -or $pubip_name.Length -lt 3){
        $pubip_name = "PUB-IP-$($vm_name)"
    }
}
$openports = @()
$openports = Read-Host -Prompt "Would you like to open specific ports? (Default: 3389, 80)"
if($openports -eq $null -or $openports.Length -lt 1){
    $openports = @(3389,80)
}

Write-Host "You are attempting to create the following
A virtual machine named $($vm_name)
This VM will be placed in RG $($resource_group_name) with location $($rglocation)
A VNET (if not existing) named $($vnet_name)
A Subnet (if not existing) named $($subnet_name)
A NSG (if not existing) named $($nsg_name)
A Public IP (if not existing) named $($pubip_name)
And finally has the following open ports configured $($openports)
"

#Validates that the are you sure question is answered with y. Elsewise throwing an error
if (areyousure -eq 'y'){
    createnewvm
}
else {
    Write-Host "The drafted VM $($vm_name) in $($resource_group_name) with location $($rglocation) will not be created. Please run the script again if necessary."
}