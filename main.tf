# Configurar a Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
    skip_provider_registration = false
  features {}
}

resource "azurerm_resource_group" "myResourceGroup" {
  name     = "myTFResourceGroup"
  location = "westus2"
}

# Cluster aks
resource "azurerm_kubernetes_cluster" "example" {
  name                = "teste-aks"
  location            = azurerm_resource_group.myResourceGroup.location
  resource_group_name = azurerm_resource_group.myResourceGroup.name
  dns_prefix          = "teste-k8s"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

 service_principal {
    client_id     = "04bc5f8c-76c9-45d8-8fb3-d8e3e7895a3e"
    client_secret = "IGFx1~7aV2J11hWAimB8izd132RNCETRYq"
  }

  role_based_access_control {
    enabled = true
  }

  addon_profile {
    http_application_routing {
      enabled = true
    }
  }
}
  
# ACR
resource "azurerm_container_registry" "register" {
  name                     = "register"
  location                 = azurerm_resource_group.myResourceGroup.location
  resource_group_name      = azurerm_resource_group.myResourceGroup.name
  sku                      = "Basic"
  admin_enabled            = false
}

output "azurerm_container_registry_id" {
  value = azurerm_container_registry.register.id
}
