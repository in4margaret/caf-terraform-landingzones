#
# Output is a single map object with each server as a key
# and an object value of information. e.g.,
#
# JenkinsServers = {
#   "JenkinsServer01" = {
#       "admin_SSH_Info" = {
#       "privateKeyFile" = "~/.ssh/id_rsa.pem"
#       "publicKeyFile" = "~/.ssh/id_rsa.pub"
#       }
#       "admin_id" = "adminuser"
#       "internal_ip" = "10.0.0.4"
#       "location" = "eastus"
#       "public_ip" = "52.168.1.129"
#       "resource_group" = "Jenkins-SE"
#       "sku" = "Standard_F2"
#       "tags" = tomap({
#       "caf_level" = "level1"
#       "caf_name" = "100-V5.tfstate"
#       "caf_stateKey" = "100-V5.tfstate"
#       "environment" = "shawn02"
#       "lastUpdated" = "2021-05-12T05:37:09Z"
#       "serverRole" = "Jenkins"
#       })
#     }
#   "JenkinsServer02" = {
#       "admin_SSH_Info" = {
#       "privateKeyFile" = "~/.ssh/id_rsa.pem"
#       "publicKeyFile" = "~/.ssh/id_rsa.pub"
#       }
#       "admin_id" = "adminuser"
#       "internal_ip" = "10.0.0.4"
#       "location" = "eastus"
#       "public_ip" = "52.168.1.148"
#       "resource_group" = "Jenkins-SE2"
#       "sku" = "Standard_F2"
#       "tags" = tomap({
#       "caf_level" = "level1"
#       "caf_name" = "100-V5.tfstate"
#       "caf_stateKey" = "100-V5.tfstate"
#       "environment" = "shawn02"
#       "lastUpdated" = "2021-05-12T05:15:49Z"
#       "serverRole" = "Jenkins"
#       })
#     }
# }

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
