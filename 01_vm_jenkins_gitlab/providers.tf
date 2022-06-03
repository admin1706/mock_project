provider "azurerm" {
  features {}
  subscription_id = "ab5b0d75-fcc1-48b8-a11f-f37918b5843d"
  client_id = "12617748-b1c6-440e-8221-375bb7261dce"
  client_secret = "o.73CRLXlY.6YBze7lSFEup1CsmYNLMMTl"
  tenant_id = "c89e6629-cb70-4258-bb1d-f752a91160bb"
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
    key                  = "codelab.microsoft.tfstate"
  }
}