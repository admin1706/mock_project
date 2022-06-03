module "vm_jenkins_gitlab" {
    source = "./01_vm_jenkins_gitlab"
    location        = "australiacentral"
    vm_count        = 1
    vm_name         = "ubuntu_1804"
    vm_image_string = "Canonical/UbuntuServer/18.04-LTS/latest"
    vm_size         = "Standard_B4ms"
    rg_name         = "assignment3"
    rg_tag          = "Production"
    admin_username  = "admin1706"
    admin_password  = "Password123!"
}

module "vm_awx" {
    source = "./02_vm_awx"
    location        = "australiacentral"
    vm_count        = 1
    vm_name         = "redhat_7"
    vm_image_string = "RedHat/RHEL/7lvm-gen2/latest"
    vm_size         = "Standard_DC4s_v3"
    vm_location     = "centralus"
    rg_name         = module.vm_jenkins_gitlab.azr_rg.name
    rg_tag          = "Production"
    admin_username  = "admin1706"
    admin_password  = "Password123!"
}

# module "postgres_db" {
#     source = "./04_postgres"
#     module.vm_jenkins_gitlab.azr_rg
# }