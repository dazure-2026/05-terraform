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
variable "location" {
    type        = string
    description = "The Azure region to deploy resources in"
    default     = "Denmark East"
}

variable "resource_group_name" {
    type        = string
    description = "The name of the resource group to create"
    default     = "dnmrk-est-rg"
}       

variable "secure_boot_enabled" {
  type = bool
  description = "Enable or disable secure boot for the virtual machine"
  default = true
}

variable "list_of_tags" {
  type = map(string)
  description = "A map of tags to apply to the resources"
  default = {
    environment = "staging"
    project     = "roboshop"
  }
}

resource "azurerm_public_ip" "main" {
  name                = "test-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static" # Use Static or Dynamic
  
}

resource "azurerm_network_interface" "main" {
  name                = "test-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "testipconfig"
    subnet_id                     = "/subscriptions/e95ed2ec-55a5-49ac-a41d-51cb0ac50b67/resourceGroups/dnmrk-est-rg/providers/Microsoft.Network/virtualNetworks/custom-vm-vnet/subnets/default"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

resource "azurerm_linux_virtual_machine" "test-vm" {
  name                = "test-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2s" # Ensure size supports Trusted Launch
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  network_interface_ids = [azurerm_network_interface.main.id]
  admin_username       = "azureuser"
  admin_password       = "P@ssw0rd123!"
  secure_boot_enabled  = var.secure_boot_enabled
  vtpm_enabled = true
  tags                 = var.list_of_tags 
  disable_password_authentication = false
  source_image_id = "/subscriptions/e95ed2ec-55a5-49ac-a41d-51cb0ac50b67/resourceGroups/dnmrk-est-rg/providers/Microsoft.Compute/galleries/rhel10/images/1.0.0"
}