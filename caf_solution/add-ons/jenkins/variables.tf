# Map of the remote data state for lower level

variable "jenkinsServers" {
}

variable "lower_storage_account_name" {
  default = {}
}
variable "lower_container_name" {
  default = {}
}
variable "lower_resource_group_name" {
  default = {}
}

variable "tfstate_storage_account_name" {
  default = {}
}
variable "tfstate_container_name" {
  default = {}
}
variable "tfstate_key" {
  default = {}
}
variable "tfstate_resource_group_name" {
  default = {}
}

variable "global_settings" {
  default = {}
}
variable "tenant_id" {
  default = {}
}
variable "landingzone" {
  default = {}
}

variable "rover_version" {
  default = null
}

variable "tags" {
  default = null
}

variable "jenkins_rg" {
  default = {}
}

variable "jenkins_vm" {
  default = {}
}
