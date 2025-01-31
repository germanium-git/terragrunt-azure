# Terragrunt-Azure
Azure Terragrunt demo. It addresses the situation where there are several environments, each of which is handled by a separate subscription.

## How to get started

Install az cli, terragrunt.
Replace the value of `subscription_id` in `env.hcl` with a respective values that match your environments.

Update the remote_state block in `root.hcl` with respective values specifiying the remote backend to store state files
```
    subscription_id      = "33333333-3333-3333-3333-333333333333""
    key                  = "${path_relative_to_include()}/terraform.tfstate"
    resource_group_name  = "<rg-name>"
    storage_account_name = "<storage account>"
    container_name       = "<container-name>"
```

Run terragrunt
```bash
# Go to environments
cd terragrunt/environments

# Initialize, Plan and Ally to all environments
terragrunt run-all init
terragrunt run-all plan
terragrunt run-all apply
```

## Cleanup terragrunt-cache

In case of a need of geeting rid of `.terragrunt-cache` and `.terragrunt.lock.hcl` files run the Powershell script [cleanup.ps1](powershell/cleanup.ps1) from the powershell folder.

```powershell
.\cleanup.ps1 -TargetPath "../terragrunt/environments"
```
