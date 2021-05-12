#
# Output is a single map object with each server as a key
# and an object value of information. e.g.,
#
#  JenkinsServers = {
#     "JenkinsServer01" = {
#        "admin_id" = "adminuser"
#        "internal_ip" = "10.0.2.4"
#        "location" = "eastus"
#        "public_ip" = "52.170.22.119"
#        "resource_group" = "Jenkins-SE"
#        "sku" = "Standard_F2"
#     }
#     "JenkinsServerABC" = {
#        "admin_id" = "adminuser"
#        "internal_ip" = "10.0.2.4"
#        "location" = "eastus"
#        "public_ip" = "52.168.77.52"
#        "resource_group" = "Jenkins-SE2"
#        "sku" = "Standard_F2"
#     }
#  }

output "JenkinsServers" {
    value = module.jenkinsServer.*[0]
}

# Debugging
#output "jenkinsServers" { value = var.jenkinsServers}
#output "lower_storage_account_name" { value = var.lower_storage_account_name }
#output "lower_container_name" { value = var.lower_container_name }
#output "lower_resource_group_name" { value = var.lower_resource_group_name }

#output "tfstate_storage_account_name" { value = var.tfstate_storage_account_name }
#output "tfstate_container_name" { value = var.tfstate_container_name }
#output "tfstate_key" { value = var.tfstate_key }
#output "tfstate_resource_group_name" { value = var.tfstate_resource_group_name }
#output "global_settings" { value = var.global_settings }
#output "tenant_id" { value = var.tenant_id }
#output "landingzone" { value = var.lower_storage_account_name }
#output "tags" { value = var.tags }
#output "rover_version" { value = var.rover_version }
