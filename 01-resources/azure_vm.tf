# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "dnmrk-est-rg"
  location = "denmarkeast"
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "roboshop-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Subnet
resource "azurerm_subnet" "main" {
  name                 = "roboshop-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Interface
resource "azurerm_network_interface" "main" {
  name                = "roboshop-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Virtual Machine
resource "azurerm_virtual_machine" "main" {
  name                  = "roboshop-vm"
  location              = "denmarkeast"
  resource_group_name   = "dnmrk-est-rg"
  vm_size               = "Standard_B1s"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  network_interface_ids = [azurerm_network_interface.main.id]

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "101-gen2"
    version   = "1.0.0"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "roboshop-vm"
    admin_username = "azureuser"
    admin_password = "Azureuser@123"  # Use secure password or SSH keys
  }

  os_profile_linux_config {
    disable_password_authentication = false  # Set to true if using SSH keys
  }
}