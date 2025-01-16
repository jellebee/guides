variable "DeployRG" {
  type = map(any)
  default = {
    resource_group_name = "CloudOps_RG"
    location            = "West Europe"
  }
}
variable "DeployAZRGVNET" {
  type = map(any)
  default = {
    vnet_name          = "CloudOps_VNET"
    privatesubnetname  = "CloudOps_Private_Subnet_1"
    publicsubnetname   = "CloudOps_Public_Subnet_1"
    firewallsubnetname = "CloudOps_Firewall_Subnet_1"

    typetag = "VNET"
    teamtag = "Cloud Operations (CloudOps)"
  }
}
variable "AZVNET_Address_Ranges" {
  type = map(any)
  default = {
    cidrblock          = ["10.0.0.0/16"]
    privatesubnetcidr  = ["10.0.1.0/24"]
    publicsubnetcidr   = ["10.0.100.0/24"]
    firewallsubnetcidr = ["10.0.100.0/24"]
  }
}
variable "DeployAZFW" {
  type = map(any)
  default = {
    pub_ip_allo_method = "Static"
    pub_ip_sku         = "Standard"
    pub_ip_name        = "CloudOps_PubIP_1"
    fwname             = "CloudOps_AZFW_1"
    sku_tier           = "Standard"
    sku_name           = "AZFW_VNet"
    ip_config_name     = "AZFW_1_IP_Config"

    typetag = "FW"
  }
}
