variable "location" {
    type        = string
    description = "The Azure region to deploy resources in"
    default     = "Denmark East"
}

variable "resource_group_name" {
    type        = string
    description = "The name of the resource group to deploy resources in"
    default     = "dnmrk-est-rg"
}

variable "secure_boot_enabled" {
  type = bool
  description = "Enable or disable secure boot for the virtual machine"
  default = true
  
}
variable "tags" {
  type = map(string)
  description = "A map of tags to apply to the resources"
  default = {
    environment = "staging"
    project     = "roboshop"
  }
}

variable "source_image_id" {
  type = string
  default = "/subscriptions/e95ed2ec-55a5-49ac-a41d-51cb0ac50b67/resourceGroups/dnmrk-est-rg/providers/Microsoft.Compute/galleries/rhel10/images/1.0.0"
}

variable "subnet_id" {
  type = string
  default = "/subscriptions/e95ed2ec-55a5-49ac-a41d-51cb0ac50b67/resourceGroups/dnmrk-est-rg/providers/Microsoft.Network/virtualNetworks/custom-vm-vnet/subnets/default"
}

variable "zone_name" {
  type = string
  default = "devaimlops.online"
}

variable "component" {
  type = map(object({
    instance_name = string
    size          = string
  }))
    default = {
        frontend = {
            instance_name = "frontend"
            size          = "Standard_B1s"
        }
        mongodb = {
            instance_name = "mongodb"
            size          = "Standard_B1s"
        }
        catalogue = {
            instance_name = "catalogue"
            size          = "Standard_B1s"
        }
        mysql = {
            instance_name = "mysql"
            size          = "Standard_B2s"
        }
        user = {
            instance_name = "user"
            size          = "Standard_B1s"
        }
        valkey = {
            instance_name = "valkey"
            size          = "Standard_B1s"
        }
        cart = {
            instance_name = "cart"
            size          = "Standard_B1s"
        }
        shipping = {
            instance_name = "shipping"
            size          = "Standard_B1s"
        }
        rabbitmq = {
            instance_name = "rabbitmq"
            size          = "Standard_B1s"
        }
        payment = {
            instance_name = "payment"
            size          = "Standard_B1s"
        }
        notification = {
            instance_name = "notification"
            size          = "Standard_B1s"
        }
        orders = {
            instance_name = "orders"
            size          = "Standard_B1s"
        }
        rating = {
            instance_name = "rating"
            size          = "Standard_B1s"
        }
    }
}