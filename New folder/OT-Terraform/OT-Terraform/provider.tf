# Terraform Setting Block
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "shubhamP"
    storage_account_name = "opstreeterraform"
    container_name       = "tfstatefiles"
    key                  = "terraform.tfstate"
  }
}

# Provider Setting Block
provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}