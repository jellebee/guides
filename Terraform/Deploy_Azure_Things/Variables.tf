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
    typetag = "Azure FireWall"
    team = "Cloud Operations (CloudOps)"
    }
}
variable "DeployAZPolicy" {
    type = map(any)
    default = {
    typetag = "Azure Policy"
    team = "Cloud Operations (CloudOps)"
    }
}
variable "DeployAZVNET" {
    type = map(any)
    default = {
    vnet_name = "CloudOps_VNET"
    location = "West Europe"
    resource_group_name = "CloudOps_RG"
    cidrblock = ["10.0.0.0/16"]
    dns_servers = ["10.0.0.4", "10.0.0.5"]

    privatesubnetname = "CloudOps_Private_Subnet_1"
    privatesubnetcidr = "10.0.1.0/24"
    publicsubnetname = "CloudOps_Public_Subnet_1"
    publicsubnetcidr = "10.0.100.0/24"

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
variable "DeployRG" {
    type = map(any)
    default = {
    name = "CloudOps_RG"
    location = "West Europe"
    typetag = "Azure Resource Group"
    team = "Cloud Operations (CloudOps)"
    }
}