landingzone = {
  backend_type        = "azurerm"
  global_settings_key = "launchpad"
  level               = "level0"
  key                 = "jenkins-demo"
  tfstates = {
    launchpad = {
      level   = "current"
      tfstate = "caf_launchpad.tfstate"
    }
  }
}

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
