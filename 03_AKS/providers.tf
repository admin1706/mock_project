provider "azurerm" {
  features {} 
}

terraform {

  required_version = ">=0.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "cloud-shell-storage-southeastasia"
    storage_account_name = "cs110032001e533981f"
    container_name       = "tfstate"
    key                  = "codelab2aks.microsoft.tfstate"
  }
}