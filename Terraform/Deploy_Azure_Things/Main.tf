module "AZRGVNET" {
  source = "./modules/DeployAZRGVNET"
 
  resource_group_name = var.DeployAZRGVNET.resource_group_name
  location = var.DeployAZRGVNET.location
  vnet_name = var.DeployAZRGVNET.vnet_name
  cidrblock = var.DeployAZRGVNET.cidrblock

  privatesubnetname = var.DeployAZRGVNET.privatesubnetname
  privatesubnetcidr = var.DeployAZRGVNET.privatesubnetcidr
  publicsubnetname = var.DeployAZRGVNET.publicsubnetname
  publicsubnetcidr = var.DeployAZRGVNET.privatesubnetcidr
  firewallsubnetname = var.DeployAZRGVNET.firewallsubnetname
  firewallsubnetcidr = var.DeployAZRGVNET.firewallsubnetcidr

  teamtag = var.DeployAZRGVNET.teamtag
  typetag = var.DeployAZRGVNET.typetag

}
module "AZBACKUP" {
  source = "./modules/DeployAZBACKUP"
}
module "AZFW" {
  source = "./modules/DeployAZFW"
  resource_group_name = var.DeployAZFW.resource_group_name
  location = var.DeployAZFW.location

  pub_ip_name = var.DeployAZFW.pub_ip_name
  pub_ip_sku = var.DeployAZFW.pub_ip_sku
  pub_ip_allo_method = var.DeployAZFW.pub_ip_allo_method

  fwname = var.DeployAZFW.fwname
  fwsubnet = var.DeployAZFW.fwsubnet
  sku_tier = var.DeployAZFW.fwsku_tier
  vnet_name = var.DeployAZFW.vnet_name
  sku_name = var.DeployAZFW.sku_name
  
  cidrblock = var.AZFW.cidrblock

  privatesubnetname = var.AZFW.privatesubnetname
  privatesubnetcidr = var.AZFW.privatesubnetcidr

}
module "AZPOLICY" {
  source = "./modules/DeployAZPolicy"
}
module "AZVM" {
  source = "./modules/DeployAZVM"
}