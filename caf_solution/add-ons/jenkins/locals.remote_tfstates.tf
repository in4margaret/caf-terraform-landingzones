locals {
  landingzone = {
    current = {
      storage_account_name = var.tfstate_storage_account_name
      container_name       = var.tfstate_container_name
      resource_group_name  = var.tfstate_resource_group_name
    }
    lower = {
      storage_account_name = var.lower_storage_account_name
      container_name       = var.lower_container_name
      resource_group_name  = var.lower_resource_group_name
    }
  }
}

data "terraform_remote_state" "remote" {
  for_each = try(var.landingzone.tfstates, {})

  backend = var.landingzone.backend_type
  config = {
    storage_account_name = local.landingzone[try(each.value.level, "current")].storage_account_name
    container_name       = local.landingzone[try(each.value.level, "current")].container_name
    resource_group_name  = local.landingzone[try(each.value.level, "current")].resource_group_name
    key                  = each.value.tfstate
  }
}

locals {
  landingzone_tag = {
    "landingzone" = var.landingzone.key
  }

  #TODO: this fiddles some values back from remote state, coping with a possible absence of
  # the environment setting's possible absence.  This is all to set environment in tags, so
  # it's unclear if this is needed.
  #
  _gsTmp = data.terraform_remote_state.remote[var.landingzone.global_settings_key].outputs
  global_settings = lookup(local._gsTmp, "global_settings", { "tags" = { }, "environment" = "None" })
  _environmentTmp = lookup(local.global_settings,"environment",null)
  environmentGlobal = null != local._environmentTmp ? { "environment" = local._environmentTmp } : { }

  tags = merge(local.global_settings.tags,
              local.landingzone_tag,
              { "level" = var.landingzone.level },
              local.environmentGlobal,
              { "rover_version" = var.rover_version },
              var.tags)

}
