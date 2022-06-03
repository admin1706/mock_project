//------------- create Ubuntu 18.04 server ----------------//

location        = "australiacentral"
vm_count        = 1
vm_name         = "ubuntu1804"
vm_name1        = "redhat"
vm_image_string = "Canonical/UbuntuServer/18.04-LTS/latest"
vm_image_string1 = "RedHat/RHEL/7lvm-gen2/latest"
vm_size         = "Standard_B4ms"
vm_location     = "centralus"
rg_name         = "assignment3"
rg_tag          = "Production"
admin_username  = "admin1706"
admin_password  = "Password123!"

