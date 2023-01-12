resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "cloudops_vnet" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.vnet_name
  address_space       = var.cidrblock

  tags = {
    Team = var.teamtag
    Type = var.typetag
  }
}

resource "azurerm_subnet" "privatesubnet" {
  name                 = var.privatesubnetname
  resource_group_name  = var.location
  virtual_network_name = azurerm_virtual_network.cloudops_vnet.name
  address_prefixes     = var.privatesubnetcidr
}

resource "azurerm_subnet" "publicsubnet" {
  name                 = var.publicsubnetname
  resource_group_name  = var.location
  virtual_network_name = azurerm_virtual_network.cloudops_vnet.name
  address_prefixes     = var.publicsubnetcidr
}

resource "azurerm_subnet" "firewallsubnet" {
  name                 = var.firewallsubnetname
  resource_group_name  = var.location
  virtual_network_name = azurerm_virtual_network.cloudops_vnet.name
  address_prefixes     = var.firewallsubnetcidr
}
