#
# Output is a single map object with each server as a key
# and an object value of information. e.g.,
#
#    JenkinsServers = {
#    "JenkinsServerBasic" = {
#        "admin_SSH_Info" = {
#        "privateKeyFile" = "~/.ssh/id_rsa.pem"
#        "publicKeyFile" = "~/.ssh/id_rsa.pub"
#        }
#        "admin_id" = "adminuser"
#        "internal_ip" = "10.0.0.4"
#        "location" = "eastus"
#        "public_ip" = "13.92.99.196"
#        "resource_group" = "Jenkins-SE"
#        "sku" = "Standard_F2"
#        "tags" = tomap({
#        "caf_level" = "level1"
#        "caf_state" = "100-V5.tfstate"
#        "caf_stateKey" = "jenkins"
#        "environment" = "shawn02"
#        "lastUpdated" = "2021-05-13T21:31:38Z"
#        "serverRole" = "Jenkins"
#        })
#        "vm_resource_id" = "/subscriptions/5fa5c7a2-43fb-43c8-a48a-dfa1e52652df/resourceGroups/Jenkins-SE/providers/Microsoft.Compute/virtualMachines/JenkinsServerBasic"
#    }
#    "JenkinsServerSpecial" = {
#        "admin_SSH_Info" = {
#        "privateKeyFile" = "~/.ssh/id_rsa.pem"
#        "publicKeyFile" = "~/.ssh/id_rsa.pub"
#        }
#        "admin_id" = "adifferentadminuser"
#        "internal_ip" = "10.0.0.4"
#        "location" = "eastus"
#        "public_ip" = "13.92.99.144"
#        "resource_group" = "Jenkins-SE-Bigger"
#        "sku" = "Standard_F4"
#        "tags" = tomap({
#        "caf_level" = "level1"
#        "caf_state" = "100-V5.tfstate"
#        "caf_stateKey" = "jenkins"
#        "environment" = "shawn02"
#        "lastUpdated" = "2021-05-13T21:31:38Z"
#        "serverRole" = "Jenkins"
#        })
#        "vm_resource_id" = "/subscriptions/5fa5c7a2-43fb-43c8-a48a-dfa1e52652df/resourceGroups/Jenkins-SE-Bigger/providers/Microsoft.Compute/virtualMachines/JenkinsServerSpecial"
#    }
#

output "JenkinsServers" {
    value = module.jenkinsServer.*[0]
}

#
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
