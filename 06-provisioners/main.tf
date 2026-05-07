resource "azurerm_public_ip" "main" {
  name                = "frontend-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_network_interface" "main" {
  name = "frontend-nic"
  location            = var.location  
  resource_group_name = var.resource_group_name
  ip_configuration {
    name = "frontend_ip_config"
    subnet_id = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = "frontend-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1s"

  os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite" 
    storage_account_type = "Standard_LRS"
  }
  network_interface_ids = [azurerm_network_interface.main.id]
  secure_boot_enabled  = var.secure_boot_enabled
  vtpm_enabled = true
  admin_username       = "azureuser"
  admin_password       = "P@ssw0rd123!"
  tags                 = var.tags
  disable_password_authentication = false
  source_image_id = var.source_image_id

  provisioner "remote-exec" {
    connection {
      host = self.public_ip_address
      type = "ssh"
      user = "azureuser"
      password = "P@ssw0rd123!"
    }
    inline = [
      "sudo dnf update -y",
      "sudo dnf install nginx -y",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]   
  }
}

resource "azurerm_dns_a_record" "main" {
  name                = "frontend-dev"
  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 30
  records             = [azurerm_linux_virtual_machine.main.public_ip_address]
}