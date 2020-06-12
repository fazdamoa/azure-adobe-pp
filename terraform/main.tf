provider "azurerm" {
  features {}
  version = "=2.14"
}

data "azurerm_resource_group" "rg" {
    name     = var.rg_name
}

data "azurerm_subnet" "sn" {
    name                 = var.subnet_name
    virtual_network_name = var.vnet_name
    resource_group_name  = var.vnet_rg
}

resource "azurerm_network_interface" "nic" {
    name                        = "${var.app_name}-nic"
    location                    = data.azurerm_resource_group.rg.location
    resource_group_name         = data.azurerm_resource_group.rg.name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = data.azurerm_subnet.sn.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.app_name}-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "rdp-in"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_windows_virtual_machine" "vm" {
    name                = "${var.app_name}-vm"
    location            = data.azurerm_resource_group.rg.location
    resource_group_name = data.azurerm_resource_group.rg.name
    size                = "NV4as_v4"
    admin_username      = "adminuser"
    admin_password      = var.admin_password
    priority            = "Spot"
    network_interface_ids = [
        azurerm_network_interface.nic.id,
    ]

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2016-Datacenter"
        version   = "latest"
    }
}

resource "azurerm_virtual_machine_extension" "extension" {
    name                 = "DSC"
    publisher                  = "Microsoft.Powershell"
    type                       = "DSC"
    type_handler_version       = "2.78"
    auto_upgrade_minor_version = true
    virtual_machine_id = azurerm_windows_virtual_machine.vm.id

    settings = jsonencode({
        "wmfVersion" : "latest",
        "configuration" : {
            "url" : "https://raw.githubusercontent.com/fazdamoa/azure-adobe-pp/master/dsccatalog/ppro.zip",
            "script" : "ppro.ps1",
            "function" : "PPro"
        },
        "privacy" : {
            "dataCollection" : "Disable"
        }
    })
}