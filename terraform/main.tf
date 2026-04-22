terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# =========================
# Resource Group
# =========================
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# =========================
# App Service Plan
# =========================
resource "azurerm_service_plan" "plan" {
  name = var.app_service_plan_name

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  os_type  = "Linux"
  sku_name = "F1"
}

# =========================
# Web App (Docker)
# =========================
resource "azurerm_linux_web_app" "app" {
  name = var.web_app_name

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    always_on = false

    application_stack {
      docker_image_name = var.docker_image_name
    }
  }
}

