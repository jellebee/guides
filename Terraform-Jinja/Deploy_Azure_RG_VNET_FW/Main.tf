module "AZFW" {
  source = "./modules/DeployAZFW"
  #For now I would only deploy it with a VNET and RG in place
  resource_group_name = var.DeployRG.resource_group_name
  location            = var.DeployRG.location

  cidrblock = var.AZVNET_Address_Ranges.cidrblock

  privatesubnetname  = var.DeployAZRGVNET.privatesubnetname
  privatesubnetcidr  = var.AZVNET_Address_Ranges.privatesubnetcidr
  publicsubnetname   = var.DeployAZRGVNET.publicsubnetname
  publicsubnetcidr   = var.AZVNET_Address_Ranges.publicsubnetcidr
  firewallsubnetname = var.DeployAZRGVNET.firewallsubnetname
  firewallsubnetcidr = var.AZVNET_Address_Ranges.firewallsubnetcidr

  pub_ip_name        = var.DeployAZFW.pub_ip_name
  pub_ip_sku         = var.DeployAZFW.pub_ip_sku
  pub_ip_allo_method = var.DeployAZFW.pub_ip_allo_method

  ip_config_name = var.DeployAZFW.ip_config_name

  fwname    = var.DeployAZFW.fwname
  sku_tier  = var.DeployAZFW.sku_tier
  vnet_name = var.DeployAZRGVNET.vnet_name
  sku_name  = var.DeployAZFW.sku_name

  teamtag     = var.DeployAZRGVNET.teamtag
  typevnettag = var.DeployAZRGVNET.typetag
  typefwtag   = var.DeployAZFW.typetag

}
