terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Keeps providers within version 3.x to prevent breaking changes
    }
  }

  # This block configures the secure remote backend
  backend "azurerm" {
    resource_group_name  = "rg-devops-portfolio-backend" # Pre-created Resource Group
    storage_account_name = "stdevopsstatebackend01"      # Pre-created, globally unique Storage Account
    container_name       = "tfstate"                     # Blob Container inside the Storage Account
    key                  = "terraform.tfstate"           # Name of the state file to create
    
    # State locking is enabled by default with Azure Blob Storage
    # The pipeline's Service Principal must have Storage Blob Data Contributor permissions
  }
}

provider "azurerm" {
  features {} # Required block for the AzureRM provider initialization
}
