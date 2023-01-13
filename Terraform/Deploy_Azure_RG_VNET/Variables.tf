variable "DeployAZRGVNET" {
  type = map(any)
  default = {
    resource_group_name = "CloudOps_RG"
    location            = "West Europe"
    vnet_name           = "CloudOps_VNET"
    privatesubnetname   = "CloudOps_Private_Subnet_1"
    publicsubnetname    = "CloudOps_Public_Subnet_1"

    typetag = "VNET"
    teamtag = "Cloud Operations (CloudOps)"
  }
}
variable "AZVNET_Address_Ranges" {
  type = map(any)
  default = {

    cidrblock = ["10.0.0.0/16"]


    privatesubnetcidr = ["10.0.1.0/24"]

    publicsubnetcidr = ["10.0.100.0/24"]
  }
}
