resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.vnet_name
  address_space       = var.cidrblock

  privatesubnet = {
    name = var.privatesubnetname
    address_space = var.privatesubnetcidr
  }
  publicsubnet = {
    name = var.publicsubnetname
    address_space = var.publicsubnetcidr
  }

  tags = {
    Team = var.teamtag
    Type = var.typetag
  }
}