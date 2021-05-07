#
# Jenkins server module.
#
locals {
  # a bit of fiddling for resource prefixes
  #  as underscores aren't allowed in some names
  _p0 = var.resourcePrefix == null ? var.vmName : var.resourcePrefix
  _p = replace(local._p0,"_","-")

  # names for the various resources
  nameRG = var.rgName
  nameVM = var.vmName
  nameVNET = "${local._p}-vnet"
  namePublicIP = "${local._p}-pip"
  nameSubnet01 = "${local._p}-sn-1"
  nameNic01 = "${local._p}-nic-1"

  serverSku = var.serverSku

  adminUser = "adminuser"

  tags = merge(
      {
        environment = "Jenkins",
        lastUpdated = timestamp()
      }, var.tags)

  location = var.location
}

resource "azurerm_resource_group" "jenrg" {
  name      = local.nameRG
  location  = local.location

  tags      = local.tags
  lifecycle { ignore_changes = [ tags["lastUpdated"] ] }
}

resource "azurerm_virtual_network" "jennetwork" {
    depends_on = [azurerm_resource_group.jenrg]
    name                = local.nameVNET
    location            = local.location
    resource_group_name = local.nameRG
    address_space       = ["10.0.0.0/16"]

    tags                = local.tags
    lifecycle { ignore_changes = [ tags["lastUpdated"] ] }
}

resource "azurerm_subnet" "jensubnet" {
    depends_on = [azurerm_virtual_network.jennetwork]
    name                 = local.nameSubnet01
    virtual_network_name = azurerm_virtual_network.jennetwork.name
    resource_group_name =  local.nameRG
    address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "jnPubIP" {
    depends_on = [azurerm_resource_group.jenrg]
    name                = local.namePublicIP
    location            = local.location
    resource_group_name = local.nameRG
    allocation_method   = "Static"
    idle_timeout_in_minutes = 30
    tags                = local.tags
    lifecycle { ignore_changes = [ tags["lastUpdated"] ] }
}

resource "azurerm_network_interface" "jennic01" {
  depends_on = [azurerm_resource_group.jenrg]
  name                = local.nameNic01
  location            = local.location
  resource_group_name = local.nameRG

  tags                = local.tags
  lifecycle { ignore_changes = [ tags["lastUpdated"] ] }

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jensubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jnPubIP.id
  }
}

locals {
    jdk = "openjdk-8-jdk"
    aptPrefix = "sudo DEBIAN_FRONTEND=noninteractive apt --yes -qq"
    aptUpdate = "${local.aptPrefix} update "
    aptInstall = "${local.aptPrefix} install "
}

resource "azurerm_linux_virtual_machine" "jenvm" {
  depends_on = [azurerm_resource_group.jenrg, azurerm_network_interface.jennic01 ]
  name                = local.nameVM
  location            = local.location
  resource_group_name = local.nameRG
  size                = local.serverSku
  network_interface_ids = [
      azurerm_network_interface.jennic01.id,
  ]
  tags                = local.tags
  lifecycle { ignore_changes = [ tags["lastUpdated"] ] }

  admin_username      = local.adminUser
  admin_ssh_key {
    username   = local.adminUser
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
      user = local.adminUser
      private_key = file("~/.ssh/SENexis_key.pem")
      host = azurerm_public_ip.jnPubIP.ip_address
    }
  }
}
