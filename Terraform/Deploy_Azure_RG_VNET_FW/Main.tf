module "AZFW" {
  source = "./modules/DeployAZFW"
  #For now I would only deploy it with a VNET and RG in place
  resource_group_name = var.DeployAZFW.resource_group_name
  location            = var.DeployAZFW.location

  pub_ip_name        = var.DeployAZFW.pub_ip_name
  pub_ip_sku         = var.DeployAZFW.pub_ip_sku
  pub_ip_allo_method = var.DeployAZFW.pub_ip_allo_method

  ip_config_name = var.DeployAZFW.ip_config_name
  pub_ipaddress  = module.AZFW.azurerm_public_ip.AZ_Pub_IP.id
  fwsubnetid     = module.AZRGVNET.azurerm_subnet.firewallsubnet.id

  fwname    = var.DeployAZFW.fwname
  sku_tier  = var.DeployAZFW.fwsku_tier
  vnet_name = var.DeployAZFW.vnet_name
  sku_name  = var.DeployAZFW.sku_name

  teamtag = var.DeployAZFW.teamtag
  typetag = var.DeployAZFW.typetag

}
