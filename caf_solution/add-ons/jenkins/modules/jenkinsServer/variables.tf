
#  Name for the VM
variable "vmName" {
    type = string
}

# Name for the resource group
variable "rgName" {
    type = string
}

# Azure location
variable "location" {
    type = string
}

# A prefix to apply to all the related resources
# in the RG.  Note that if vmName is specified,
# that will be the name of the VM.  If it is not
# specified, a name will be reconstructed.
variable "resourcePrefix" {
    type = string
    default = null
}

# Resource tags to apply to each resource
variable "tags" {
    type = map
    default = null
}

# Optionally override the server SKU.
variable "serverSku" {
    type = string
    default = "Standard_F2"
}
