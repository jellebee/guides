module "AZRG" {
  source = "./modules/DeployAZRG"
  
  name = var.DeployRG.name
  location = var.DeployRG.location
}
module "AZVNET" {
  source = "./modules/DeployAZVNET"

  vnet_name = var.network
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