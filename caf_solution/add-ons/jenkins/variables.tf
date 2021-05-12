# Variables from the users's TF file

variable "jenkinsServers" {
  description = "A map of server information with keys == Servername"
  type = map
}

variable "global_settings" {
  description = "Global settings object (see module README.md)"
  default = {}
}
variable "landingzone" {
  default = {}
}

variable "tags" {
  type = map
  default = null
}

# Exported from rover via environment variables.  e.g.,
# https://github.com/aztfmod/rover/blob/5e65914803542638a262cc2f87d17f77cb06007c/scripts/tfc.sh#L167

variable "tenant_id" { }
variable "lower_storage_account_name" { }
variable "lower_container_name" { }
variable "lower_resource_group_name" { }
variable "tfstate_storage_account_name" { }
variable "tfstate_container_name" { }
variable "tfstate_resource_group_name" { }
variable "tfstate_key" { }
variable "tf_name" { }
variable "level" { }
variable "rover_version" { # set by Rover
  type = string
  default = null
}
variable "environment" { }

#####################################
#Debugging
#output "VarGlobalSettings" { value = var.global_settings }
#output "VarLandingZone" { value = var.landingzone }
#output "VarTags" { value = var.tags }
