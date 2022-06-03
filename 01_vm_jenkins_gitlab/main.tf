//------------- create Ubuntu 18.04 server ----------------//
resource "azurerm_resource_group" "mock_project-rg" {
  name     = "${var.rg_name}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "network" {
  name                = "${var.rg_name}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.mock_project-rg.location
  resource_group_name = azurerm_resource_group.mock_project-rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.mock_project-rg.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource   "azurerm_public_ip"   "public_ip"   {
  #  count                 =   "${var.vm_count}"
   name                  =   "public-ip" 
   location              =   azurerm_resource_group.mock_project-rg.location
   resource_group_name   =   azurerm_resource_group.mock_project-rg.name
   allocation_method     =   "Static" 
   sku                   =   "Basic" 
 } 

resource "azurerm_network_interface" "network_interface" {
  name                = "${var.rg_name}-nic"
  location            = azurerm_resource_group.mock_project-rg.location
  resource_group_name = azurerm_resource_group.mock_project-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.rg_name}-nsg"
  location            = azurerm_resource_group.mock_project-rg.location
  resource_group_name = azurerm_resource_group.mock_project-rg.name

  security_rule {
    name              = "allow ALL" 
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_linux_virtual_machine" "ubuntu" {
  name                  = "${var.vm_name}machine"
  location              = azurerm_resource_group.mock_project-rg.location
  resource_group_name   = azurerm_resource_group.mock_project-rg.name
  size                  = "${var.vm_size}"
  admin_username        = "${var.admin_username}"
  admin_password        = "${var.admin_password}"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]

  # admin_ssh_key {
  #   username   = "${var.admin_username}"
  #   public_key = file("~/.ssh/id_rsa.pub")
  # }

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

  # connection {
  #   type        = "ssh"
  #   user        = "${var.admin_username}"
  #   password    = "${var.admin_password}"
  #   host        = azurerm_public_ip.public_ip.fqdn
  # }

  # provisioner "remote_exec" {
  #   command     = ["ansible-playbook playbook.yml -i inventory"]
  # }
}

# data "azurerm_data_share" "ubuntu_public_ip" {
#   name                  = "share_ubuntu_public_ip"
#   ubuntu_public_ip = azurerm_network_interface.network_interface.public_ip_address_id
# }

locals {
  local_command = <<-EOT
      cd /home/osboxes/mock_project/ansible
      echo ubuntu ansible_host=%{if length(azurerm_linux_virtual_machine.ubuntu.public_ip_addresses) > 0 }"${join("\", \"", azurerm_linux_virtual_machine.ubuntu.public_ip_addresses)}"%{else}""%{endif} ansible_connection=ssh ansible_user="${azurerm_linux_virtual_machine.ubuntu.admin_username}" ansible_ssh_pass="${azurerm_linux_virtual_machine.ubuntu.admin_password}" >> inventory
      echo redhat ansible_host=%{if length(azurerm_linux_virtual_machine.redhat.public_ip_addresses) > 0 }"${join("\", \"", azurerm_linux_virtual_machine.redhat.public_ip_addresses)}"%{else}""%{endif} ansible_connection=ssh ansible_user="${azurerm_linux_virtual_machine.redhat.admin_username}" ansible_ssh_pass="${azurerm_linux_virtual_machine.redhat.admin_password}" >> inventory
      ansible-playbook playbook.yml -i inventory
    EOT
    sensitive = true
}

resource "time_sleep" "waiting_3min" {
  create_duration = "180s"
  depends_on = [
    azurerm_linux_virtual_machine.ubuntu,
    azurerm_linux_virtual_machine.redhat,
    azurerm_network_security_group.nsg,
    azurerm_network_interface.network_interface,
    azurerm_network_interface.network_interface1,
    azurerm_public_ip.public_ip,
    azurerm_public_ip.public_ip1
  ]
}
resource "null_resource" "local_exec" {
  depends_on = [
    time_sleep.waiting_3min
  ]

  provisioner "local-exec" {
    command =   local.local_command
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "cd mock_project/ansible/",
  #     "echo ubuntu ansible_host=${output.vm_01_ip} ansible_connection=ssh ansible_user=${var.admin_username} ansible_ssh_pass=${var.admin_password}",
  #     "ansible-playbook playbook.yml -i inventory"
  #   ]
  # }
}
