#
# Example provisioning two Jenkins servers in the named Resource Groups
#

jenkinsServers = {
  JenkinsServer01 = {
    resource_group_name = "Jenkins-SE"
    location = "eastus"
  },
  JenkinsServer02 = {
    resource_group_name = "Jenkins-SE2"
    location = "eastus"
  }
}
