terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.40"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 2.2.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 2.1.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 1.2.0"
    }

  }
  required_version = ">= 0.13"
}

provider "azurerm" {
  features {
  }
}

#TODO: Is this needed?
data "azurerm_client_config" "current" { }

locals {

  # Rover will fill in level as per command line, but let user override it via landingzone
  caf_level = lookup(var.landingzone, "level", var.level)
  caf_key = lookup(var.landingzone, "key", var.tfstate_key)

  backend = {
    azurerm = {
      storage_account_name = var.tfstate_storage_account_name
      container_name       = var.tfstate_container_name
      resource_group_name  = var.tfstate_resource_group_name
      key                  = var.tfstate_key
      level                = local.caf_level
      tenant_id            = var.tenant_id
      subscription_id      = data.azurerm_client_config.current.subscription_id
    }
  }

  tags_computed = merge( {
        caf_level = local.caf_level,
        caf_stateKey = local.caf_key,
        caf_name = var.tf_name,
        environment = var.environment,
      },
      var.tags)

 #TODO: is this needed?

 # # Update the tfstates map
 # tfstates = merge(
 #   tomap( { (var.landingzone.key) = local.backend[var.landingzone.backend_type] } ),
 #   data.terraform_remote_state.remote[var.landingzone.global_settings_key].outputs.tfstates
 # )

}
