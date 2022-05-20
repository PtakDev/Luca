# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  
  skip_provider_registration = true
}


# Create a virtual network within the resource group
resource "azurerm_virtual_network" "piotrNet" {
  name                = "piotrNet"
  resource_group_name = "Resource-Group-LUCA"
  location            = "West Europe"
  address_space       = ["12.12.0.0/16"]
}
