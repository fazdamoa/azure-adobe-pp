variable "location" {}
variable "vnet_name" {}
variable "vnet_rg"  {}   
variable "subnet_name" {}
variable "rg_name" {}    
variable "app_name" {}
variable "admin_password" { default = "Password123!" }

variable shutdown_timezone { default = "GMT Standard Time" }
variable shutdown_time { description = "Time in 24 hour time" default = "2200" }