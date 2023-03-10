<#
Hi Guys, I made a small script for creating a PSQL Server with DB from PS. I will also add an AZCLI file up later. 
You can use it freely, wherever necessary. 

From the azure portal ìn the right top you have a way to click on the Powershell icon (cloudshell) and press powershell.
#>
$local = Read-Host -Prompt "Are you running the script locally? Say 'yes' or 'y' elsewise AZ connection will not be established."
if ($local -eq "yes" -or $local -eq "y") {
    #Before doing anything, importing the module and connecting to Azure
    Import-Module -Name Az
    Connect-AzAccount
}

function areyousure {
    #Just to double check that you would like to continue
    $areyousure = Read-host -Prompt "Would you like to create a PSQL server [1] , a PSQL DB [2], or both?"
    if ($areyousure -eq 'y') {
        return $areyousure
        continue
    }
    else {
        break
    }
}

function createnewserver {
    try {
        $adminUsername = Read-Host -Prompt "Please enter the administrator username for the PostgreSQL server"
        $adminPassword = Read-Host -Prompt "Please enter the administrator password for the PostgreSQL server" -AsSecureString
        $location = Read-Host -Prompt "Please enter the location for the server (default: EastUS)"
        if (!$resourceGroupName) {
            break
        }

        if ((!$location) -or $location.Length -lt 3) {
            $location = "EastUS"
        }

        $sku = New-AzPostgreSqlServerSku -Name "GP_Gen5_2" -Tier "GeneralPurpose" -Capacity 2

        $server = New-AzPostgreSqlServer `
            -ResourceGroupName $resourceGroupName `
            -ServerName $serverName `
            -Location $location `
            -ServerVersion "10" `
            -Sku $sku `
            -SqlAdministratorCredentials (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminUsername, $adminPassword)

        Write-Host "PostgreSQL server $($server.ServerName) has been created in resource group $($server.ResourceGroupName) in location $($server.Location)"
    }
    catch {
        Write-Host "An error has occurred. Please check the error listed $($Error[0])"
    }
}
function createpsqldb ($resourceGroupName, $serverName) {
    $databasename = ""
    if (!$databasename) {
        $databasename = "Please enter the name for the PSQL DB..."
    }
    Write-Host "Your name has been set to $($databasename)"
    New-AzPostgreSQLDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $databasename
}

$check = areyousure
if ($check -eq '1') {
    $resourceGroupName = Read-Host -Prompt "Please enter the name of the resource group that the server will be deployed in"
    $serverName = Read-Host -Prompt "Please enter the name for the PostgreSQL server"
    createnewserver
}
elseif ($check -eq '2') {
    $resourceGroupName = Read-Host -Prompt "Please enter the name of the resource group that the server will be deployed in"
    $serverName = Read-Host -Prompt "Please enter the name for the PostgreSQL server"
}
elseif ($check -eq '3') {
    $resourceGroupName = Read-Host -Prompt "Please enter the name of the resource group that the server will be deployed in"
    $serverName = Read-Host -Prompt "Please enter the name for the PostgreSQL server"
    if (createnewserver) {
        createpsqldb
    }
}
else {
    Write-Host "The PostgreSQL server nor the PostgreSQL DB will not be created. Please run the script again if necessary. Error: $($Error[0])"
}