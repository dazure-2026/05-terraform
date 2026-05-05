# 1. Create the Public IP Address
resource "azurerm_public_ip" "main" {
  name                = "test-pip"
  location            = "Denmark East"
  resource_group_name = "dnmrk-est-rg"
  allocation_method   = "Static" # Use Static or Dynamic
  sku                 = "Standard"
}

resource "azurerm_network_interface" "main" {
  name                = "test-nic"
  location            = "Denmark East"
  resource_group_name = "dnmrk-est-rg"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "/subscriptions/e95ed2ec-55a5-49ac-a41d-51cb0ac50b67/resourceGroups/dnmrk-est-rg/providers/Microsoft.Network/virtualNetworks/custom-vm-vnet/subnets/default"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

# resource "azurerm_virtual_machine" "main" {
#   name                  = "test-vm"
#   location            = "Denmark East"
#   resource_group_name = "dnmrk-est-rg"
#   network_interface_ids = [azurerm_network_interface.main.id]
#   vm_size               = "Standard_B1s"

#   # Uncomment this line to delete the OS disk automatically when deleting the VM
#   delete_os_disk_on_termination = true

#   # Uncomment this line to delete the data disks automatically when deleting the VM
#   delete_data_disks_on_termination = true

#   storage_image_reference {
#     #id = "/subscriptions/e95ed2ec-55a5-49ac-a41d-51cb0ac50b67/resourceGroups/dnmrk-est-rg/providers/Microsoft.Compute/galleries/rhel10"
#     id = "/subscriptions/e95ed2ec-55a5-49ac-a41d-51cb0ac50b67/resourceGroups/dnmrk-est-rg/providers/Microsoft.Compute/galleries/rhel10/images/1.0.0"

#     # publisher = "RedHat"
#     # offer     = "RHEL"
#     # sku       = "101-gen2"
#     # version   = "latest"
#   }
#   storage_os_disk {
#     name              = "myosdisk1"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }
#   os_profile {
#     computer_name  = "test-vm"
#     admin_username = "azureuser"
#     admin_password = "Azureuser@123"
#   }
#   os_profile_linux_config {
#     disable_password_authentication = false
#   }
  
#   tags = {
#     environment = "staging"
#   }
# }

resource "azurerm_linux_virtual_machine" "test-vm" {
  name                = "test-vm"
  resource_group_name = "dnmrk-est-rg"
  location            = "East US" # Replace with your location
  size                = "Standard_B2s" # Ensure size supports Trusted Launch
  admin_username      = "azureuser"
  
  # Use source_image_id instead of storage_image_reference
  source_image_id = "/subscriptions/e95ed2ec-55a5-49ac-a41d-51cb0ac50b67/resourceGroups/dnmrk-est-rg/providers/Microsoft.Compute/galleries/rhel10/images/1.0.0"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # This enables Trusted Launch
  secure_boot_enabled = true
  vtpm_enabled        = true

  network_interface_ids = [azurerm_network_interface.main.id]
  admin_password = "Azureuser@123" # Use a secure password or consider using SSH keys for better security
}