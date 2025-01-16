module "AZRGVNET" {
  source = "./modules/DeployAZRGVNET"

  resource_group_name = var.DeployAZRGVNET.resource_group_name
  location            = var.DeployAZRGVNET.location
  vnet_name           = var.DeployAZRGVNET.vnet_name
  cidrblock           = var.AZVNET_Address_Ranges.cidrblock

  privatesubnetname = var.DeployAZRGVNET.privatesubnetname
  privatesubnetcidr = var.AZVNET_Address_Ranges.privatesubnetcidr
  publicsubnetname  = var.DeployAZRGVNET.publicsubnetname
  publicsubnetcidr  = var.AZVNET_Address_Ranges.publicsubnetcidr

  teamtag = var.DeployAZRGVNET.teamtag
  typetag = var.DeployAZRGVNET.typetag

}
