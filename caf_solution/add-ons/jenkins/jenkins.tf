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

resource "azurerm_public_ip" "jnPubIP" {
    depends_on = [azurerm_resource_group.jenrg]
    for_each   = try(var.jenkins_rg, {})
  name                = "jnPubIP"
  location            = azurerm_resource_group.jenrg[each.key].location
  resource_group_name = azurerm_resource_group.jenrg[each.key].name
  allocation_method = "Static"
  idle_timeout_in_minutes      = 30

  tags = {
    environment = "shawn"
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
    public_ip_address_id = azurerm_public_ip.jnPubIP[each.key].id
  }
}

locals {
    jdk = "openjdk-8-jdk"
    aptPrefix = "sudo DEBIAN_FRONTEND=noninteractive apt --yes -qq"
    aptUpdate = "${local.aptPrefix} update "
    aptInstall = "${local.aptPrefix} install "
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

  provisioner "remote-exec" {
    inline = [
      # general update
      "echo '===[01]==='; ${local.aptUpdate}",
      # install Java SDK
      "echo '===[02]==='; ${local.aptInstall} ${local.jdk}",
      # Install Jenkins
      "echo '===[03]==='; wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -",
      "echo '===[04]==='; sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "echo '===[05]==='; ${local.aptUpdate}",
      "echo '===[06]==='; ${local.aptInstall} jenkins",
      # Start Jenkins service
      "echo '===[07]==='; sudo systemctl start jenkins",
      "echo '===[08]===';",
    ]
    connection {
      type = "ssh"
      user = "adminuser"
      private_key = file("~/.ssh/SENexis_key.pem")
      host = azurerm_public_ip.jnPubIP[each.key].ip_address
    }
  }
}
