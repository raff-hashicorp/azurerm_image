resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_network_interface" "example" {
  name                = "test-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "testconfiguration1"
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_virtual_machine" "example" {
  name                  = "acctestvm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_D1_v2"

  storage_os_disk {
    name          = "myosdisk1"
    create_option = "FromImage"
  }
}

resource "azurerm_image" "example" {
  name                = "acctest"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  os_disk {
    os_type  = "Linux"
    os_state = "Generalized"
    blob_uri = azurerm_virtual_machine.example.storage_os_disk[0].vhd_uri
    size_gb  = 30
  }
}
