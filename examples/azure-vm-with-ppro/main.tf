provider "azurerm" {
  features {}
  version = ">=2.14"
}

module "azure-vm" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "github.com/fazdamoa/azure-adobe-pp//modules/azure-vm?ref=v0.0.1"
    source = "../../modules/azure-vm"
    location = "UK South"
    vnet_rg = "fazthebro"
    vnet_name = "fazthebro-vnet"
    subnet_name = "default"
    rg_name = "fazthebro"
    app_name = "premier"
    apps_to_install = "PPro19"
    shutdown_timezone = "GMT Standard Time"
    shutdown_time = "2200"
}

output "pip" {
  value = module.azure-vm.public_ip_address
}