resource   "azurerm_public_ip"   "public_ip1"   {
  #  count                 =   "${var.vm_count}"
   name                  =   "public-ip1" 
   location              =   azurerm_resource_group.mock_project-rg.location
   resource_group_name   =   azurerm_resource_group.mock_project-rg.name
   allocation_method     =   "Static" 
   sku                   =   "Basic" 
 } 

resource "azurerm_network_interface" "network_interface1" {
  name                = "${var.rg_name}-1-nic"
  location            = azurerm_resource_group.mock_project-rg.location
  resource_group_name = azurerm_resource_group.mock_project-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip1.id
  }
}

resource "azurerm_linux_virtual_machine" "redhat" {
  name                  = "${var.vm_name1}-machine"
  location              = "${var.vm_location}"
  resource_group_name   = azurerm_resource_group.mock_project-rg.name
  size                  = "${var.vm_size}"
  admin_username        = "${var.admin_username}"
  admin_password        = "${var.admin_password}"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.network_interface1.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "${element(split("/", var.vm_image_string1), 0)}"
    offer     = "${element(split("/", var.vm_image_string1), 1)}"
    sku       = "${element(split("/", var.vm_image_string1), 2)}"
    version   = "${element(split("/", var.vm_image_string1), 3)}"
  }
}