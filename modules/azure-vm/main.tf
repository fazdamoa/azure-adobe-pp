data "azurerm_resource_group" "rg" {
    name     = var.rg_name
}

data "azurerm_subnet" "sn" {
    name                 = var.subnet_name
    virtual_network_name = var.vnet_name
    resource_group_name  = var.vnet_rg
}

resource "azurerm_public_ip" "pip" {
    name                = "${var.app_name}-pip"
    location                    = data.azurerm_resource_group.rg.location
    resource_group_name         = data.azurerm_resource_group.rg.name
    allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
    name                        = "${var.app_name}-nic"
    location                    = data.azurerm_resource_group.rg.location
    resource_group_name         = data.azurerm_resource_group.rg.name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = data.azurerm_subnet.sn.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.pip.id
    }
}

# Get IP of execution machine for RDP whitelist
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.app_name}-nsg"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "rdp-in"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${chomp(data.http.myip.body)}/32"
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
    size                = var.vm_size
    admin_username      = "adminuser"
    admin_password      = var.admin_password
    #priority            = "Spot"
    #eviction_policy     = "Deallocate"

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
        sku       = "2019-Datacenter"
        version   = "latest"
    }
}

resource "azurerm_virtual_machine_extension" "extension" {
  name                 = "installapps"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = jsonencode({
      "commandToExecute": "powershell.exe -command './install-vm.ps1' ${var.apps_to_install}",
      "fileUris": [
          "https://raw.githubusercontent.com/fazdamoa/azure-adobe-pp/master/modules/install-apps/install-vm.ps1",
          "https://raw.githubusercontent.com/fazdamoa/azure-adobe-pp/master/modules/install-apps/install-prereq.ps1",
          "https://raw.githubusercontent.com/fazdamoa/azure-adobe-pp/master/modules/install-apps/get-adobe-apps.ps1"
      ]
  })
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown" {
    virtual_machine_id = azurerm_windows_virtual_machine.vm.id
    location           = var.location
    enabled            = true

    daily_recurrence_time = var.shutdown_time
    timezone              = var.shutdown_timezone

    notification_settings {
        enabled         = false
    }
}