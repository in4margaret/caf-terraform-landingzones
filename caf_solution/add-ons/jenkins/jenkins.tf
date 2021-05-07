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
}

#
# Output is a single object with each server as a key and an object value
# of information.
#
#  JenkinsServers = {
#    "Server01" = {
#      "admin_id" = "adminuser"
#      "internal_ip" = "10.0.2.4"
#      "public_ip" = "13.82.215.195"
#    }
#  }

output "JenkinsServers" {
    value = module.jenkinsServer.*[0]
}
