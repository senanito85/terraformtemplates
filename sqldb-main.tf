# Configure Azure Provider
provider "azurerm" {
           #source          = "hashicorp/azurerm"
           version        = "=2.71.0"
           #version         = "=1.44.0"
           subscription_id = "090fed9b-7d1b-457f-ae88-4f8b1c7db8d8"
           tenant_id       = "f468fabe-2703-4cd3-b5ee-2f23373abca2"
           features {}
}

# Configure new RG
resource "azurerm_resource_group" "rg" {
    name         = "SSAD_DB_RG"
    location     = "Australia East"

    tags = {
        Environment = "SSAD"
        Team        = "DevOps"
    }
}

# Add network
resource "azurerm_virtual_network" "example" {
  name                = "ssad-network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.10.0.0/16"]
}

# Add Storage Account
resource "azurerm_storage_account" "resStorAcc" {
  name                     = "esarestoracc"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# resource "azurerm_mssql_server" "ssad-sqlsrv" {
#   name                         = "sqlserver"
#   resource_group_name          = azurerm_resource_group.example.name
#   location                     = azurerm_resource_group.example.location
#   version                      = "12.0"
#   administrator_login          = "mradmin"
#   administrator_login_password = "********"
#}

resource "azurerm_sql_server" "mssqlsrv" {
  name                         = "ssad-mssqlserver"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "mrdadmin"
  administrator_login_password = "************"

}
