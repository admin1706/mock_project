//------------- export Ubuntu 18.04 server ----------------//
output "vm_01_ip" {
  value = azurerm_linux_virtual_machine.ubuntu.public_ip_addresses
  # sensitive = true
}

output "azr_rg" {
  value = azurerm_resource_group.mock_project-rg
}

output "network_interface" {
  value = azurerm_network_interface.network_interface
}

output "virtual_network" {
  value = azurerm_virtual_network.network
}

output "subnet" {
  value = azurerm_subnet.subnet
}

output "nsg" {
  value = azurerm_network_security_group.nsg
}