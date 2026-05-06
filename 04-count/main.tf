resource "null_resource" "main" {
  count = 10
}

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