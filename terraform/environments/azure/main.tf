terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}

provider "azurerm" { 
  features {} 
  }

# Resource Group
resource "azurerm_resource_group" "example" {
  name     = "rg-secure-infra"
  location = "East US"
}

# VNet for isolation
resource "azurerm_virtual_network" "example" {
  name                = "vnet-secure"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Storage Account with encryption
resource "azurerm_storage_account" "example" {
  name                     = "mystorageaccountsecure"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  https_traffic_only_enabled = true  # Encryption
  allow_nested_items_to_be_public = false  # Access control
}

# VM with encryption and access controls
resource "azurerm_linux_virtual_machine" "example" {
  name                = "vm-secure"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")  # Use keys, not passwords
  }
  encryption_at_host_enabled = true  # Host encryption
  network_interface_ids = [azurerm_network_interface.example.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }
}

# Network Interface (private IP only)
resource "azurerm_network_interface" "example" {
  name                = "nic-secure"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Subnet
resource "azurerm_subnet" "example" {
  name                 = "subnet-secure"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}