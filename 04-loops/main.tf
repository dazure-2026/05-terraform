# This file contains the main Terraform configuration for creating multiple resources using loops.
# It demonstrates how to use the `count` meta-argument to create multiple instances of a resource based on a list of components.
# observe that if one more component is added to the list, it actually removes one resource 
# resource "null_resource" "main" {
#   count = 10
# }

variable "component" {
  type = list(string)
  default = [ "frontend", "backend", "database" ]
}

resource "azurerm_network_interface" "main" {
    count = 3
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