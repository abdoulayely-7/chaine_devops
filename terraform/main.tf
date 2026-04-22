terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-chaine_devops"
  location = "West Europe"
}

resource "azurerm_service_plan" "plan" {
  name                = "plan-chaine_devops"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  os_type  = "Linux"
  sku_name = "F1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "chaine_devops-web-odc"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    always_on = false

    application_stack {
      docker_image_name = "abdoulayely777/chaine_devops-web:latest"
    }
  }
}