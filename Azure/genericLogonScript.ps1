<#
    This script checks if you are logged in to both the Azure CLI and Azure PowerShell.
    If not logged in, it will prompt you to log in.
    The script aims to prevent repeated login prompts if you already have an active session.

    Steps:
    1. Check for an active Azure CLI session using `az account list`.
    2. Check for an active Azure PowerShell session using `Get-AzContext`.
    3. Log in to Azure CLI if no session is found.
    4. Log in to Azure PowerShell if no session is found.
    This script also includes features to address authentication issues related to the "Status_InteractionRequired" error in Azure CLI.
    It provides steps to perform an explicit login with the needed scope and clear cached account information if necessary.
#>
param(
    [string]$tenant #ReplaceMe with your tenant
)
function ExplicitLogin {
    param (
        [bool]$isCLI=$false
    )

    if(-not $isCli){
        Write-Output "Attempting explicit Azure Powershell login to Tenant: $tenant"
        Connect-AzAccount -UseDeviceAuthentication -TenantId $tenant
    } else {
        # Try to log in explicitly with the specified scope
        Write-Output "Attempting explicit Azure CLI login with scope: $tenant"
        az login --use-device-code --tenant $tenant
    }
}

function ClearAzAccountCache {
    param(
        [bool]$isCLI=$false
    )
    if(-not $isCLI){
        # Clear any cached Azure account information
        Write-Output "Clearing Azure Powershell account cache..."
        Clear-AzContext -Force
    } else {
        # Clear any cached Azure account information
        Write-Output "Clearing Azure CLI account cache..."
        az account clear
    }
}

#Running all AzPowerShellLogincheck
try {
    $groupcheck = Get-AzResourceGroup | Out-Null
    if ($groupCheck.Count -eq 0) {
        Write-Output "No active Azure CLI session detected. Attempting login..."
        ExplicitLogin
    }
}
catch {
    # If there's an authentication error, clear cache and log in again
    Write-Output "Authentication error detected. Clearing cache. Please rerun the script!"
    ClearAzAccountCache
    ExplicitLogin
}

#Running all AzCliLogincheck
try {
    # Check if the user is logged in
    $groupCheck = az group list --output none

    if ($groupCheck.Count -eq 0) {
        Write-Output "No active Azure CLI session detected. Attempting login..."
        ExplicitLogin($true)
    } else {
        Write-Output "Azure CLI session is active."
    }
} catch {
    # If there's an authentication error, clear cache and log in again
    Write-Output "Authentication error detected. Clearing cache. Please rerun the script!"
    ClearAzAccountCache($true)
}