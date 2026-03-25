terraform {
  required_version = "1.14.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.37.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.65.0"
    }
  }
  backend "s3" {
    bucket = "mateusmota-remote-state"
    key    = "pipeline-github/terraform.tfstate"
    region = "sa-east-1"
  }
}

provider "aws" {
  region = "sa-east-1"

  default_tags {
    tags = {
      owner      = "ronaldo nazário"
      managed-by = "terraform"
    }
  }
}

provider "azurerm" {
  features {}
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "mateusmota-remote-state"
    key    = "aws-vpc/terraform.tfstate"
    region = "sa-east-1"
  }
}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "mateusmotaterraformstate"
    container_name       = "remote-state"
    key                  = "azure-vnet/terraform.tfstate"
  }
}