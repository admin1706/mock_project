//------------- create Ubuntu 18.04 server ----------------//

location        = "australiacentral"
vm_count        = 1
vm_name         = "ubuntu1804"
vm_image_string = "Canonical/UbuntuServer/18.04-LTS/latest"
vm_size         = "Standard_B4ms"
rg_name         = "assignment3"
rg_tag          = "Production"
admin_username  = "admin1706"
admin_password  = "Password123!"

