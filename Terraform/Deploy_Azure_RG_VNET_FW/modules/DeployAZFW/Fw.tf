resource "azurerm_public_ip" "AZ_Pub_IP" {
  name                = var.pub_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.pub_ip_allo_method
  sku                 = var.pub_ip_sku
}

resource "azurerm_firewall" "AZ_FW" {
  name                = var.fwname
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier

  ip_configuration {
    name                 = var.ip_config_name
    subnet_id            = var.fwsubnetid
    public_ip_address_id = azurerm_public_ip.AZ_Pub_IP.id
  }
}
