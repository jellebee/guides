variable "DeployAZBACKUP" {
    type = map(any)
    default = {
    typetag = "Azure Backup"
    team = "Cloud Operations (CloudOps)"
    }
}
variable "DeployAZFW" {
    type = map(any)
    default = {
    
    pub_ip_allo_method = "Static"
    pub_ip_sku = "Standard"
    pub_ip_name = "testpip"

    fwname = "MyFW"
    fwsubnet = ""
    fwsku_tier = ""
    sku_name = "AZFW CloudOps"

    typetag = "Azure FireWall"
    teamtag = "Cloud Operations (CloudOps)"
    }
}
variable "DeployAZPolicy" {
    type = map(any)
    default = {
    typetag = "Azure Policy"
    team = "Cloud Operations (CloudOps)"
    }
}
variable "DeployAZRGVNET" {
    type = map(any)
    default = {
    resource_group_name = "CloudOps_RG"
    location = "West Europe"
    vnet_name = "CloudOps_VNET"
    cidrblock = ["10.0.0.0/16"]

    privatesubnetname = "CloudOps_Private_Subnet_1"
    privatesubnetcidr = "10.0.1.0/24"
    publicsubnetname = "CloudOps_Public_Subnet_1"
    publicsubnetcidr = "10.0.100.0/24"
    firewallsubnetname = "Firewall_Subnet_1"
    fwsubnetcidr = "10.0.200.0/24"

    typetag = "VNET"
    teamtag = "Cloud Operations (CloudOps)"
    }
}
variable "DeployAZVM" {
    type = map(any)
    default = {
    typetag = "Azure Virtual Machine"
    team = "Cloud Operations (CloudOps)"
    }
}