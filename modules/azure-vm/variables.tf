variable "location" {}
variable "vnet_name" {}
variable "vnet_rg"  {}   
variable "subnet_name" {}
variable "rg_name" {}    
variable "app_name" {}
variable "admin_password" { default = "Password123!" }
variable "vm_size" {
    default = "Standard_NC6_Promo"
    description = "Default value is GPU promo." 
}
variable "apps_to_install" { 
    type = string
    description = "Must be: PPro19"
}
variable "shutdown_timezone" { default = "GMT Standard Time" }
variable "shutdown_time" { 
    description = "Time in 24 hour time"
    default = "2200" 
}