# Add-on to deploy Jenkins Server for Azure CAF landing zones

Supported scenario in this release:

1. Create the Jenkins Server based on Azure VM.

## Creating the TFC environment

This will setup Jenkins server.

```bash
# Deploy
rover -lz /tf/caf/caf_solution/add-ons/jenkins/ -var-folder /tf/caf/caf_solution/add-ons/jenkins/example -a apply

or
cd /tf/caf/landingzones/caf_launchpad/add-ons/terraform_cloud/
terraform init
terraform plan -var-file /tf/caf/caf_solution/add-ons/jenkins/example/jnks.tfvars
```

Once ready, you can create your configuration:

```bash
terraform apply \
-var-file /tf/caf/caf_solution/add-ons/jenkins/example/jnks.tfvars
```
