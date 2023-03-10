# Define variables to be used in the resource blocks
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to create"
}

variable "location" {
  type        = string
  description = "Location for the resources"
  default     = "eastus"
}

variable "server_name" {
  type        = string
  description = "Name of the PostgreSQL server to create"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the PostgreSQL server"
}

variable "admin_password" {
  type        = string
  description = "Admin password for the PostgreSQL server"
}

variable "database_name" {
  type        = string
  description = "Name of the PostgreSQL database to create"
}
