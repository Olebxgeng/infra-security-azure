terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "secure_infra" {
  name     = "rg-secure-infra-prod"  
  location = "East US"               
}

# VNet for isolation
resource "azurerm_virtual_network" "secure_vnet" {
  name                = "vnet-secure-prod"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.secure_infra.location
  resource_group_name = azurerm_resource_group.secure_infra.name
}

# Storage Account with encryption
resource "azurerm_storage_account" "secure_storage" {
  name                     = "mystorageaccountsecureprod"  
  resource_group_name      = azurerm_resource_group.secure_infra.name
  location                 = azurerm_resource_group.secure_infra.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  https_traffic_only_enabled = true  # Encryption
  allow_nested_items_to_be_public= false  # Access control
}

# VM with encryption and access controls
resource "azurerm_linux_virtual_machine" "secure_vm" {
  name                = "vm-secure-prod"
  resource_group_name = azurerm_resource_group.secure_infra.name
  location            = azurerm_resource_group.secure_infra.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")  
  }
  encryption_at_host_enabled = true  # Host encryption
  network_interface_ids = [azurerm_network_interface.secure_nic.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }
}

# Network Interface (private IP only)
resource "azurerm_network_interface" "secure_nic" {
  name                = "nic-secure-prod"
  location            = azurerm_resource_group.secure_infra.location
  resource_group_name = azurerm_resource_group.secure_infra.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.secure_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Subnet
resource "azurerm_subnet" "secure_subnet" {
  name                 = "subnet-secure-prod"
  resource_group_name  = azurerm_resource_group.secure_infra.name
  virtual_network_name = azurerm_virtual_network.secure_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# RBAC: Assign Reader role to a user on the Resource Group
resource "azurerm_role_assignment" "rg_reader" {
  scope                = azurerm_resource_group.secure_infra.id
  role_definition_name = "Reader"
  principal_id         = "<user-object-id>"  
}

# RBAC: Assign Contributor role to a service principal on the Storage Account
resource "azurerm_role_assignment" "storage_contributor" {
  scope                = azurerm_storage_account.secure_storage.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = "<service-principal-id>"  
}

# RBAC: Assign Virtual Machine Contributor on the VM
resource "azurerm_role_assignment" "vm_contributor" {
  scope                = azurerm_linux_virtual_machine.secure_vm.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = "<principal-id>"  
}