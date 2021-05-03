resource "azurerm_resource_group" "jenrg" {
 for_each = try(var.jenkins_rg, {})
  name                     = each.value.group_name
  location                 = each.value.location
    tags = {
        environment = "Jenkins"
    }
}

resource "azurerm_virtual_network" "jennetwork" {
    depends_on = [azurerm_resource_group.jenrg]
    for_each   = try(var.jenkins_rg, {})

    name                = "myVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.jenrg[each.key].name

    tags = {
        environment = "Jenkins"
    }
}

resource "azurerm_subnet" "jensubnet" {
    depends_on = [azurerm_resource_group.jenrg, azurerm_virtual_network.jennetwork]
    for_each   = try(var.jenkins_rg, {})
    name                 = "mySubnet"
    resource_group_name  = azurerm_resource_group.jenrg[each.key].name
    virtual_network_name = azurerm_virtual_network.jennetwork[each.key].name
    address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "jennic" {
      depends_on = [azurerm_resource_group.jenrg]
    for_each   = try(var.jenkins_rg, {})
  name                = "jennic"
  location            = azurerm_resource_group.jenrg[each.key].location
  resource_group_name = azurerm_resource_group.jenrg[each.key].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jensubnet[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "jenvm" {
      depends_on = [azurerm_resource_group.jenrg]
    for_each   = try(var.jenkins_rg, {})
  name                = "jen-machine"
  resource_group_name = azurerm_resource_group.jenrg[each.key].name
  location            = azurerm_resource_group.jenrg[each.key].location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.jennic[each.key].id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
