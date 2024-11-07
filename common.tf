locals {
  naming_convention_info = {
    project_code = "pc"
    env          = "env"
    zone         = "zn"
    tier         = "www"
    name         = "name"
    agency_code  = "ac"
  }
   tags = {
    environment = "prd"
  }
}

data "azurerm_client_config" "current" {}

module "resource_groups" {
  source = "git::https://github.com/BrettOJ/tf-az-module-resource-group?ref=main"
  resource_groups = {
    1 = {
      name                   = var.resource_group_name
      location               = var.location
      naming_convention_info = local.naming_convention_info
      tags = local.tags
    }
  }
}

module "azurerm_log_analytics_workspace" {
  source                                  = "git::https://github.com/BrettOJ/tf-az-module-azure-log-analytics-workspace?ref=main"
  location                                = var.location
  resource_group_name                     = module.resource_groups.rg_output[1].name
  allow_resource_only_permissions         = var.allow_resource_only_permissions
  local_authentication_disabled           = var.local_authentication_disabled
  sku                                     = var.sku
  retention_in_days                       = var.retention_in_days
  daily_quota_gb                          = var.daily_quota_gb
  cmk_for_query_forced                    = var.cmk_for_query_forced
  internet_ingestion_enabled              = var.internet_ingestion_enabled
  internet_query_enabled                  = var.internet_query_enabled
  reservation_capacity_in_gb_per_day      = var.reservation_capacity_in_gb_per_day
  data_collection_rule_id                 = var.data_collection_rule_id
  immediate_data_purge_on_30_days_enabled = var.immediate_data_purge_on_30_days_enabled
  tags                                    = local.tags
  naming_convention_info                  = local.naming_convention_info

  identity = {
    type         = var.identity_type
    identity_ids = var.identity_identity_ids
  }
}

module "azurerm_application_insights" {
  source                                = "git::https://github.com/BrettOJ/tf-az-module-azure-application-insights?ref=main"
  location                              = var.location
  resource_group_name                   = module.resource_groups.rg_output[1].name
  workspace_id                          = module.azurerm_log_analytics_workspace.law_output.id
  application_type                      = var.application_type
  daily_data_cap_in_gb                  = var.daily_data_cap_in_gb
  daily_data_cap_notifications_disabled = var.daily_data_cap_notifications_disabled
  retention_in_days                     = var.retention_in_days
  sampling_percentage                   = var.sampling_percentage
  disable_ip_masking                    = var.disable_ip_masking
  tags                                  = local.tags
  local_authentication_disabled         = var.local_authentication_disabled
  internet_ingestion_enabled            = var.internet_ingestion_enabled
  internet_query_enabled                = var.internet_query_enabled
  force_customer_storage_for_profiler   = var.force_customer_storage_for_profiler
  naming_convention_info                = local.naming_convention_info
}


module "azure_storage_account" {
  source                 = "git::https://github.com/BrettOJ/tf-az-module-azure-storage-account?ref=main"
  resource_group_name    = module.resource_groups.rg_output.1.name
  location               = var.location
  account_kind           = "StorageV2"
  account_tier           = "Standard"
  min_tls_version        = "TLS1_2"
  tags                   = local.tags
  naming_convention_info = local.naming_convention_info
  share_properties       = null

  containers = {
    lvl0 = {
      name        = "lvl0"
      access_type = "private"
    }
    lvl1 = {
      name        = "lvl1"
      access_type = "private"
    }
    lvl2 = {
      name        = "lvl2"
      access_type = "private"
    }
  }
/*
  network_rules = {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules       = null
    virtual_network_subnet_ids = [module.azure_subnet.snet_output[1].id]
    private_link_access = null

}*/
}

module "azurerm_key_vault" {
  source              = "git::https://github.com/BrettOJ/tf-az-module-azure-key-vault?ref=main" 
  resource_group_name = module.resource_groups.rg_output[1].name
  location            = var.location
  sku_name    = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  enable_rbac_authorization       = true
  purge_protection_enabled        = true
  public_network_access_enabled   = true
  soft_delete_retention_days      = 7 


  network_acls = {
      bypass         = "AzureServices"
      default_action = "Allow"
      ip_rules       = null
      virtual_network_subnet_ids     = null
    }
  
  naming_convention_info = local.naming_convention_info
  tags                   = local.tags
}

module "azurerm_machine_learning_workspace" {
  source                         = "git::https://github.com/BrettOJ/tf-az-module-azure-ml-workspace?ref=main" 
  location                       = var.location
  resource_group_name            = module.resource_groups.rg_output[1].name
  application_insights_id        = module.azurerm_application_insights.app_insights_output.id
  key_vault_id                   = module.azurerm_key_vault.key_vault_id
  storage_account_id             = module.azure_storage_account.sst_output.id
  kind                           = var.ml_ws_kind
  container_registry_id          = null #var.container_registry_id
  public_network_access_enabled  = var.ml_ws_public_network_access_enabled 
  image_build_compute_name       = var.image_build_compute_name
  description                    = var.description
  friendly_name                  = var.friendly_name
  high_business_impact           = var.high_business_impact
  primary_user_assigned_identity = null #module.azurerm_user_assigned_identity.msi_output.id
  v1_legacy_mode_enabled         = var.v1_legacy_mode_enabled
  sku_name                       = var.sku_name
  tags                           = local.tags
  naming_convention_info = local.naming_convention_info

  identity = {
    type = "SystemAssigned"
    identity_ids = null
  }

  managed_network = {
    isolation_mode = var.managed_network_isolation_mode
  }

  serverless_compute = {
    subnet_id         = var.serverless_compute_subnet_id
    public_ip_enabled = var.serverless_compute_public_ip_enabled
  }

  depends_on = [
  ]
}


