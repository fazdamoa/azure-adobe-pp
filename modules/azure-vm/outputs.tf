data "azurerm_public_ip" "pipvalue" {
  name                = azurerm_public_ip.pip.name
  resource_group_name = azurerm_windows_virtual_machine.vm.resource_group_name
}

output "public_ip_address" {
  value = data.azurerm_public_ip.pipvalue.ip_address
}