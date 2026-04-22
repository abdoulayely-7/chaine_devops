variable "resource_group_name" {
  description = "Nom du Resource Group"
  type        = string
  default     = "rg-chaine-devops"
}

variable "location" {
  description = "Région Azure"
  type        = string
  default     = "spaincentral"
}

variable "app_service_plan_name" {
  description = "Nom du App Service Plan"
  type        = string
  default     = "plan-chaine-devops"
}

variable "web_app_name" {
  description = "Nom de l'application web"
  type        = string
  default     = "chaine-devops-app"
}

variable "docker_image_name" {
  description = "Image Docker"
  type        = string
  default     = "abdoulayely777/chaine_devops:latest"
}