<#
Description: This script is used to create and assign Azure Policies for ensuring secure configurations. It includes a policy to enforce secure transfer for storage accounts and another custom policy to deny resource creation in regions outside specified locations.

You can start using the script like this:
.\PolicyCreationScript.ps1 -SubscriptionId "yourSubscriptionId" -ResourceGroupName "yourResourceGroupName"

References:
Azure Policies Documentation: https://learn.microsoft.com/en-us/azure/governance/policy/overview
#>

param (
    [string]$SubscriptionId,
    [string]$ResourceGroupName
)

Install-Module -Name Az -AllowClobber -Scope CurrentUser
Connect-AzAccount

$policyDefinition = Get-AzPolicyDefinition | Where-Object { $_.Properties.DisplayName -eq "Audit use of secure transfer in Azure Storage account" }

New-AzPolicyAssignment -Name "EnforceSecureTransferOnStorageAccounts" `
    -DisplayName "Enforce Secure Transfer on Storage Accounts" `
    -Scope "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName" `
    -PolicyDefinition $policyDefinition

$policyRule = @{
    "if" = @{
        "field" = "location"
        "notIn" = @("westeurope", "northeurope", "centraleurope")
    }
    "then" = @{
        "effect" = "deny"
    }
}

$customPolicyDefinition = New-AzPolicyDefinition -Name "Deny-NonEUResources" `
    -DisplayName "Deny Resource Creation Outside Western, Northern, and Central Europe" `
    -Description "Deny the creation of resources in regions outside westeurope, northeurope, and centraleurope." `
    -Policy $policyRule

New-AzPolicyAssignment -Name "DenyNonEUResources" `
    -DisplayName "Deny Non-EU Resources" `
    -Scope "/subscriptions/$SubscriptionId" `
    -PolicyDefinition $customPolicyDefinition