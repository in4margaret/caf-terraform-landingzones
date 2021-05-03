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

jenkins_rg = {
  j_vm = {
    group_name  = "jnvm"
    location = "eastus"
  }
}
