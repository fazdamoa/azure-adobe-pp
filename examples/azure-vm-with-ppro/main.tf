provider "azurerm" {
  features {}
  version = ">=2.14"
}

module "azure-vm" {
    source = "github.com/fazdamoa/azure-adobe-pp//modules/azure-vm"
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