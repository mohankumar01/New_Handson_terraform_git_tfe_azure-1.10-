resource "azurerm_subnet" "app-sn" {
  name                 = "web-sn-terra-git-demo"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "web-sn" {
  name                 = "app-sn-terra-git-demo"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.0.2.0/24"]
}