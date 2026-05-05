resource "azurerm_resource_group" "main" {
  name     = "main"
  location = "denmarkeast"
}   

provider "azurerm" {
  features {
    
  }
}