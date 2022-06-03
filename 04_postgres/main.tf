resource "azurerm_resource_group" "servicepostgress" {
  name     = var.rg_name
  location = var.location
}

module "vm_jenkins_gitlab" {
  source = "../01_vm_jenkins_gitlab"
  location        = "australiacentral"
  vm_count        = 1
  vm_name         = "ubuntu_1804"
  vm_image_string = "Canonical/UbuntuServer/18.04-LTS/latest"
  vm_size         = "Standard_B4ms"
  rg_name         = "assignment3"
  rg_tag          = "Production"
  admin_username  = "admin1706"
  admin_password  = "Password123!"
  # azurerm_resource_group = module.vm_jenkins_gitlab.azr_rg
}

resource "azurerm_postgresql_server" "postgress-vm" {
  name                = var.vm_name
  location            = azurerm_resource_group.servicepostgress.location
  resource_group_name = azurerm_resource_group.servicepostgress.name

  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password

  sku_name   = "GP_Gen5_4"
  version    = "9.6"
  storage_mb = 5120

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  
  ssl_minimal_tls_version_enforced = "TLS1_2"
}