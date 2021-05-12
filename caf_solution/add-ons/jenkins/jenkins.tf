#
# Module to Provision a Jenkins server in it's own
# resource group and VNET.
#
module "jenkinsServer" {
    for_each = try(var.jenkinsServers, {})
    source = "./modules/jenkinsServer"

    vmName = replace(each.key,"_","-")
    rgName = each.value.resource_group_name
    location = each.value.location
    resourcePrefix = replace(each.key,"_","-")
    global_settings = var.global_settings
    tags = local.tags_computed
}
