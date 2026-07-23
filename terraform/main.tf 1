# 1. Resource Group with dynamic environment suffix
resource "azurerm_resource_group" "network_rg" {
  name     = "rg-enterprise-${var.environment}-networks"
  location = "East US"
}

# 2. Virtual Network
resource "azurerm_virtual_network" "main_vnet" {
  name                = "vnet-${var.environment}-core"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
  address_space       = var.vnet_address_space
}

# 3. Secure Subnet
resource "azurerm_subnet" "app_subnet" {
  name                 = "snet-${var.environment}-apps"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = var.subnet_address_prefix
}

# 4. Network Security Group (Firewall Boundaries)
resource "azurerm_network_security_group" "app_nsg" {
  name                = "nsg-${var.environment}-secure-rules"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name

  # Enforce Zero-Trust: Deny all internet inbound traffic by default
  security_rule {
    name                       = "Deny_All_Internet_Inbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

# 5. Bind NSG directly to the Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_bind" {
  subnet_id                 = azurerm_subnet.app_subnet.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}
