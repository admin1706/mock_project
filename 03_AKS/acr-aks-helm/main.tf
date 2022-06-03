terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.2"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "ab5b0d75-fcc1-48b8-a11f-f37918b5843d"
  client_id = "12617748-b1c6-440e-8221-375bb7261dce"
  client_secret = "o.73CRLXlY.6YBze7lSFEup1CsmYNLMMTl"
  tenant_id = "c89e6629-cb70-4258-bb1d-f752a91160bb"
}
resource "azurerm_resource_group" "acr_aks" {
  name     = "ACR-AKS"
  location = "eastasia"
}
resource "azurerm_container_registry" "acr" {
  name                = "danglm"
  resource_group_name = azurerm_resource_group.acr_aks.name
  location            = azurerm_resource_group.acr_aks.location
  sku                 = "Standard"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "AKS"
  location            = azurerm_resource_group.acr_aks.location
  resource_group_name = azurerm_resource_group.acr_aks.name
  dns_prefix          = "AKS-DNS"
  default_node_pool {
    name       = "pod1"
    node_count = 1
    vm_size    = "Standard_B2s"
  }
  identity {
    type = "SystemAssigned"
  }
  tags = {
    Environment = "Standard"
  }
}
resource "azurerm_role_assignment" "connect_aks" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
resource "local_file" "kube_config" {
  filename = "aks_config"
  content  = azurerm_kubernetes_cluster.aks.kube_config_raw
}