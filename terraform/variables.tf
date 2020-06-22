variable "location" {}
variable "vnet_name" {}
variable "vnet_rg"  {}   
variable "subnet_name" {}
variable "rg_name" {}    
variable "app_name" {}
variable "vm_size" { default = "Standard_NC6_Promo", description = "Default value is GPU promo."}
variable "admin_password" { default = "Password123!" }
variable "apps_to_install" { type = "string", description = "Must be: PPro19" }