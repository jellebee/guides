terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  #
  subscription_id = var.subscriptiondetails.subscription_id
  tenant_id       = var.subscriptiondetails.tenant_id
  client_id       = var.subscriptiondetails.client_id
  client_secret   = var.subscriptiondetails.client_secret
  features {}
}
