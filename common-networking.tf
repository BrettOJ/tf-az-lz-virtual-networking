data "azurerm_virtual_network" "vpn_network" {
  name                = "vnet-pc-envznwww-name"
  resource_group_name = "rg-vet-s2s-vpn"
}


module "azure_virtual_network"  {
  source              = "git::https://github.com/BrettOJ/tf-az-module-virtual-network?ref=main"
  location            = var.location
  resource_group_name = module.resource_groups.rg_output[1].name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  naming_convention_info = local.naming_convention_info
  tags = local.tags

  }

module "azure_subnet" {
  source = "git::https://github.com/BrettOJ/tf-az-module-network-subnet?ref=main"
  resource_group_name  = module.resource_groups.rg_output[1].name
  virtual_network_name = module.azure_virtual_network.vnets_output.name
  location               = var.location
  naming_convention_info = local.naming_convention_info
  tags                   = local.tags
  create_nsg = var.create_nsg
  subnets = {
  001 = {
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.ContainerRegistry", "Microsoft.KeyVault"]
      private_endpoint_network_policies_enabled = null
      route_table_id    = null
      delegation  = null
      nsg_inbound = []
      nsg_outbound = []
    }
  }
  
}


module "azure_private_endpoint" {
  source = "git::https://github.com/BrettOJ/tf-az-module-private-endpoint?ref=main"

  location                      = var.location
  resource_group_name           = module.resource_groups.rg_output[1].name
  subnet_id                     = module.azure_subnet.snet_output[1].id
  custom_network_interface_name = var.custom_network_interface_name
  tags                          = local.tags
  naming_convention_info        = local.naming_convention_info
  ip_configuration = null

  private_service_connection = {
    name                              = var.private_service_connection_name
    private_connection_resource_id    = module.azure_storage_account.sst_output.id
    is_manual_connection              = var.private_service_connection_is_manual_connection
    private_connection_resource_alias = var.private_service_connection_private_connection_resource_alias
    subresource_names                 = var.private_service_connection_subresource_names
    request_message                   = var.private_service_connection_request_message
  }

  private_dns_zone_group = {
    name                 = var.private_dns_zone_group_name
    private_dns_zone_ids = [module.azure_private_dns_zone.azprvdns_output.id]
    }
    depends_on = [ module.azure_private_dns_zone ]
  }



module "azure_private_dns_zone" {
  source = "git::https://github.com/BrettOJ/tf-az-module-azure-private-dns-zone?ref=main"
  domain_name                = var.domain_name
  resource_group_name = module.resource_groups.rg_output[1].name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "example-link"
  resource_group_name   = module.resource_groups.rg_output[1].name
  private_dns_zone_name = module.azure_private_dns_zone.azprvdns_output.name
  virtual_network_id    = module.azure_virtual_network.vnets_output.id
}



module "azure_virtual_network_peering" {
  source = "git::https://github.com/BrettOJ/tf-az-module-network-peering?ref=main"
  resource_group_name          = module.resource_groups.resource_group_output[0].name
  virtual_network_name         = module.azure_virtual_network.vnets_output.name
  remote_virtual_network_id    = data.azurerm_virtual_network.vpn_network.id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.allow_gateway_transit 
  use_remote_gateways          = var.use_remote_gateways
  local_subnet_names           = var.local_subnet_names
  remote_subnet_names          = var.remote_subnet_names
  only_ipv6_peering_enabled    = var.only_ipv6_peering_enabled
  triggers = var.triggers
}