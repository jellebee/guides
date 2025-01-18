<#
Description: This script sets security contacts, configures security pricing. It's designed to ensure comprehensive security oversight.
Ensure that you are in the right subscription.
Please replace all variables set in "param" with your values.
You could opt to include default values here too by using $SecurityEmail="myemail@domain.com"!

References:
- Azure Security Contact Configuration: https://learn.microsoft.com/en-us/azure/security-center/security-center-provide-security-contact-details
- Azure Security Pricing Configuration: https://learn.microsoft.com/en-us/azure/security-center/security-center-pricing
#>

param (
    [string]$SecurityEmail,
    [string]$PhoneNumber,
    [string]$ResourceGroupName,
	[string]$PricingTier="standard"
)

Install-Module -Name Az -AllowClobber -Scope CurrentUser
Connect-AzAccount

Set-AzSecurityContact -Email $SecurityEmail `
    -PhoneNumber $PhoneNumber `
    -AlertsToAdmins "On" `
    -AlertNotifications "On"

Set-AzSecurityPricing -Name VirtualMachines `
    -PricingTier $PricingTier

