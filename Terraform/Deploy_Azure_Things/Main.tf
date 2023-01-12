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

  teamtag = var.DeployAZRGVNET.teamtag
  typetag = var.DeployAZRGVNET.typetag

}
module "AZBACKUP" {
  source = "./modules/DeployAZBACKUP"
}
module "AZFW" {
  source = "./modules/DeployAZFW"
}
module "AZPOLICY" {
  source = "./modules/DeployAZPolicy"
}
module "AZVM" {
  source = "./modules/DeployAZVM"
}