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
    typetag = "VNET"
    team = "Cloud Operations (CloudOps)"
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