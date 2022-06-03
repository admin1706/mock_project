//------------- create Ubuntu 18.04 server ----------------//
resource "azurerm_resource_group" "mock_project-rg" {
  name     = "${var.rg_name}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "network" {
  name                = "${var.vm_name}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.vm_location}"
  resource_group_name = azurerm_resource_group.mock_project-rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.mock_project-rg.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource   "azurerm_public_ip"   "public_ip"   {
   name                  =   "public-ip" 
   location              =   "${var.vm_location}"
   resource_group_name   =   azurerm_resource_group.mock_project-rg.name
   allocation_method     =   "Static" 
   sku                   =   "Basic" 
 } 

resource "azurerm_network_interface" "network_interface" {
  name                = "${var.vm_name}-nic"
  location            = "${var.vm_location}"
  resource_group_name = azurerm_resource_group.mock_project-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vm_name}-nsg"
  location            = "${var.vm_location}"
  resource_group_name = azurerm_resource_group.mock_project-rg.name

  security_rule {
    name              = "allow ALL" 
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Any"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_linux_virtual_machine" "redhat" {
  name                = "${var.vm_name}-machine"
  location              =   "${var.vm_location}"
  resource_group_name   =   azurerm_resource_group.mock_project-rg.name
  size                = "${var.vm_size}"
  admin_username      = "${var.admin_username}"
  admin_password      = "${var.admin_password}"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "${element(split("/", var.vm_image_string), 0)}"
    offer     = "${element(split("/", var.vm_image_string), 1)}"
    sku       = "${element(split("/", var.vm_image_string), 2)}"
    version   = "${element(split("/", var.vm_image_string), 3)}"
  }

}

# null_resource "remote_exe" {
#   connection {
#     type      = "ssh"
#     user      = "${var.admin_username}"
#     password  = "${var.admin_password}"
#   }

#   provisioner "remote-exec" {
#     command   = ["ansible-playbook playbook.yml -i inventory"]
#   }
# }