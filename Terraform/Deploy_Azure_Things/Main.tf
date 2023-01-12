module "AZRG" {
  source = "./modules/DeployAZRG"
  
  name = var.DeployRG.name
  location = var.DeployRG.location
}
module "AZVNET" {
  source = "./modules/DeployAZVNET"

  vnet_name = var.DeployAZVNET.vnet_name
  resource_group_name = var.DeployAZVNET.resource_group_name
  location = var.DeployAZVNET.location
  cidrblock = var.DeployAZVNET.cidrblock

  privatesubnetname = var.DeployAZVNET.privatesubnetname
  privatesubnetcidr = var.DeployAZVNET.privatesubnetcidr
  publicsubnetname = var.DeployAZVNET.publicsubnetname
  publicsubnetcidr = var.DeployAZVNET.privatesubnetcidr

  teamtag = var.DeployAZVNET.teamtag
  typetag = var.DeployAZVNET.typetag

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