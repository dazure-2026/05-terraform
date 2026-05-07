resource "azurerm_public_ip" "main" {
  name                = "test-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static" # Use Static or Dynamic
  sku = "Standard"
}

resource "azurerm_network_interface" "main" {
  for_each = var.component
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${each.key}-ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = each.key == "frontend" ? azurerm_public_ip.main.id : null
  }
}

resource "azurerm_linux_virtual_machine" "test-vm" {
  for_each = var.component
  name                = "${each.key}-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = each.value.size

  os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

    network_interface_ids = [azurerm_network_interface.main[each.key].id]
    admin_username       = "azureuser"
    admin_password       = "Azureuser@123"
    secure_boot_enabled  = var.secure_boot_enabled
    vtpm_enabled = true
    tags = var.tags
    disable_password_authentication = false
    source_image_id = var.source_image_id
}

resource "azurerm_dns_a_record" "main" {
  for_each = var.component
  name                = "${each.key}-dev"
  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 30
  records =  each.key == "frontend" ? [ azurerm_linux_virtual_machine.test-vm[each.key].public_ip_address ] : [azurerm_linux_virtual_machine.test-vm[each.key].private_ip_address]
}