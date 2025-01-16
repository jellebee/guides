resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "cloudops_vnet" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = var.vnet_name
  address_space       = var.cidrblock

  tags = {
    Team = var.teamtag
    Type = var.typevnettag
  }
}

resource "azurerm_subnet" "privatesubnet" {
  name                 = var.privatesubnetname
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.cloudops_vnet.name
  address_prefixes     = var.privatesubnetcidr
}

resource "azurerm_subnet" "publicsubnet" {
  name                 = var.publicsubnetname
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.cloudops_vnet.name
  address_prefixes     = var.publicsubnetcidr
}

resource "azurerm_subnet" "firewallsubnet" {
  name                 = var.firewallsubnetname
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.cloudops_vnet.name
  address_prefixes     = var.publicsubnetcidr
}

resource "azurerm_public_ip" "AZ_Pub_IP" {
  name                = var.pub_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = var.pub_ip_allo_method
  sku                 = var.pub_ip_sku
}

resource "azurerm_firewall" "AZ_FW" {
  name                = var.fwname
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier

  ip_configuration {
    name                 = var.ip_config_name
    subnet_id            = azurerm_subnet.firewallsubnet.id
    public_ip_address_id = azurerm_public_ip.AZ_Pub_IP.id
  }

  tags = {
    Team = var.teamtag
    Type = var.typefwtag
  }
}
