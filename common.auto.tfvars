resource_group_name = "rg-virtual-network-test"
location = "southeastasia"
address_space = [ "10.0.0.0/16" ]
dns_servers = [ "168.63.129.16" ]
create_nsg = false

# Private EndPoint Configuration
custom_network_interface_name = "nic-azure-private-endpoint"
private_service_connection_name                              = "psc-azure-private-endpoint"
private_service_connection_is_manual_connection              = true
private_service_connection_private_connection_resource_alias = null
private_service_connection_subresource_names                  = ["blob"]
private_service_connection_request_message                   = "request-message-azure-private-endpoint"
private_dns_zone_group_name                 = "pdzg-azure-private-endpoint"
domain_name = "privatelink.blob.core.windows.net"

#ML workspace values
managed_network_isolation_mode       = "Disabled"
serverless_compute_subnet_id                 = null
serverless_compute_public_ip_enabled         = true
feature_store_computer_spark_runtime_version = "2.4.x"
feature_store_offline_connection_name        = null
feature_store_online_connection_name         = null
container_registry_id = null
ml_ws_public_network_access_enabled = true
image_build_compute_name = null
description = "Azure Machine Learning Workspace"
friendly_name = "Azure Machine Learning Workspace"
high_business_impact = false
v1_legacy_mode_enabled = false
sku_name = "Basic"
ml_ws_kind = "Default"

#LAW values
allow_resource_only_permissions         = false
local_authentication_disabled           = false
sku                                     = "PerGB2018"
retention_in_days                       = 30
daily_quota_gb                          = null
cmk_for_query_forced                    = false
internet_ingestion_enabled              = false
internet_query_enabled                  = false
reservation_capacity_in_gb_per_day      = null
data_collection_rule_id                 = null
immediate_data_purge_on_30_days_enabled = false
identity_type                           = "SystemAssigned"
identity_identity_ids                   = null

#App Insights values
application_type                      = "web"
daily_data_cap_in_gb                  = 100
daily_data_cap_notifications_disabled = false
sampling_percentage                   = 100
disable_ip_masking                    = false
force_customer_storage_for_profiler   = false

# virtual network peering values
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
  local_subnet_names           = module.azure_subnet.snet_output[0].name
  remote_subnet_names          = "snet-pc-envznwww-1"
  only_ipv6_peering_enabled    = false