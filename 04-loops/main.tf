# This file contains the main Terraform configuration for creating multiple resources using loops.
# It demonstrates how to use the count meta-argument to create multiple instances of a resource based on a list.
# Note that if the order of items in the list changes, Terraform will destroy existing resources and recreate them. 
# This happens because Terraform identifies each instance by its index (e.g., [0], [1]).To avoid this, use for_each. 
# It uses the actual values (keys) as identifiers. If you change the order of the list, 
# Terraform will see that the keys haven't changed and will not trigger any unnecessary recreations
# resource "null_resource" "main" {
#   count = 10
# }

variable "component" {
  type = list(string)
  default = [ "frontend", "backend", "catalogue", "database" ]
}

resource "azurerm_network_interface" "main" {
    count = var.component != null ? length(var.component) : 0
    name                = "${var.component[count.index]}-${count.index}"
    location            = "Denmark East"
    resource_group_name = "dnmrk-est-rg"
    
    ip_configuration {
        name                          = "${var.component[count.index]}-ipconfig"
        subnet_id                     = "/subscriptions/e95ed2ec-55a5-49ac-a41d-51cb0ac50b67/resourceGroups/dnmrk-est-rg/providers/Microsoft.Network/virtualNetworks/custom-vm-vnet/subnets/default"
        private_ip_address_allocation = "Dynamic"
        # public_ip_address_id = azurerm_public_ip.main.id
    }
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.71.0"
    }
  }
}
provider "azurerm" {
  features {}
}