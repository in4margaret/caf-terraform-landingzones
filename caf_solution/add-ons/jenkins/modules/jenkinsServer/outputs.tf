#
# Outputs from the Jenkins Server module.
#

output "internal_ip" {
  value = azurerm_linux_virtual_machine.jenvm.private_ip_address
}

output "public_ip" {
  value = azurerm_linux_virtual_machine.jenvm.public_ip_address
}

output "admin_id" {
    value = local.adminUser
}

output "resource_group" {
    value = local.nameRG
}

output "location" {
    value = local.location
}

output "sku" {
    value = local.serverSku
}
