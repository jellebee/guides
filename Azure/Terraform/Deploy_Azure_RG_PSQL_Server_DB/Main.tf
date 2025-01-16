# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create the PostgreSQL server
resource "azurerm_postgresql_server" "psql" {
  name                         = var.server_name
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  version                      = "10"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password

  sku {
    name     = "GP_Gen5_2"
    tier     = "GeneralPurpose"
    capacity = 2
  }

  # Create a firewall rule to allow access from all IPs
  # Note: This is not recommended for production use
  dynamic "firewall_rule" {
    for_each = [1]
    content {
      name                    = "allow-all"
      start_ip_address        = "0.0.0.0"
      end_ip_address          = "255.255.255.255"
      azure_firewall_priority = 100
    }
  }
}

# Create the PostgreSQL database
resource "azurerm_postgresql_database" "psqldb" {
  name                = var.database_name
  server_name         = azurerm_postgresql_server.psql.name
  resource_group_name = azurerm_postgresql_server.psql.resource_group_name
}
