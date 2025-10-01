# ------------------- Web NSG (allow internet on 80/443, allow healthcheck, deny other inbound) -------------------
resource "azurerm_network_security_group" "nsg_web" {
  name                = "nsg-web-terra-git-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  
}

resource "azurerm_network_security_rule" "web_allow_http" {
  name                        = "Allow-HTTP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_web.name
  description                 = "Allow HTTP from Internet"
}

resource "azurerm_network_security_rule" "web_allow_https" {
  name                        = "Allow-HTTPS"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["443"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_web.name
  description                 = "Allow HTTPS from Internet"
}

# Optionally allow SSH from admin IP only (replace with your IP CIDR)
resource "azurerm_network_security_rule" "web_allow_ssh_admin" {
  name                        = "Allow-SSH-Admin"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["22"]
  source_address_prefix       = "203.0.113.0/32" # <- replace with your management IP/CIDR
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_web.name
  description                 = "Allow SSH only from admin IP"
}

# Deny other inbound (explicit deny rule not required because Azure default is Deny; but if you want explicit)
resource "azurerm_network_security_rule" "web_deny_all_inbound" {
  name                        = "Deny-All-Inbound"
  priority                    = 4090
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_web.name
  description                 = "Deny all other inbound"
}

# Outbound - allow all (default allows outbound). If you want to restrict, add rules here.
# -----------------------------------------------------------------------------------------------------------------

# ------------------- App NSG (only allow traffic from web subnet on app port) -------------------
resource "azurerm_network_security_group" "nsg_app" {
  name                = "nsg-app-terra-git-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

}

# Allow traffic from web subnet to app (example port 8080)
resource "azurerm_network_security_rule" "app_allow_from_web" {
  name                        = "Allow-From-Web"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["8080"]                   # change to your app port(s)
  source_address_prefix       = azurerm_subnet.web.address_prefixes[0] # uses web subnet CIDR
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_app.name
  description                 = "Allow app traffic only from web subnet"
}

# Allow DB admin or SSH from admin IP if needed
resource "azurerm_network_security_rule" "app_allow_admin_ssh" {
  name                        = "Allow-SSH-Admin-App"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["22"]
  source_address_prefix       = "203.0.113.0/32"  # replace with admin IP
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_app.name
  description                 = "Allow SSH from admin IP"
}

resource "azurerm_network_security_rule" "app_deny_all_inbound" {
  name                        = "Deny-All-Inbound-App"
  priority                    = 4090
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_app.name
  description                 = "Deny all other inbound to app subnet"
}
