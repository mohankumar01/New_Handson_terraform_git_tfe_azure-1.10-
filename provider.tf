# Terraform Settings Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
    source = "hashicorp/azurerm"
    version = ">= 3.0.0" # Optional but recommended in production
    }   
   
        }
}
provider "azurerm" {
  features {}
}
