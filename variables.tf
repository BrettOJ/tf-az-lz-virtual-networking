
variable "address_space" {
 type = list(string)
}

variable "location" {
  type = string
  default = "southeastasia"
}

variable "resource_group_name" {
  type = string
  default = "vnet-rg"
}

variable "bgp_community" {
  type = string
  default = null
}
  
variable "ddos_protection_plan" {
  type = map(any)
  default = {
    id = ""
    enable = false
  }
}

variable "encryption" {
  type = map(any)
  default = {
    enforcement = ""
  }
}

variable "dns_servers" {
  type = list(string)
  default = [""]
}

variable "flow_timeout_in_minutes" {
  type = number
  default = 4
}

variable "create_nsg" {
  type = bool
  default = false
  
}

## Storage Account Variables

variable "account_kind" {
  type        = string
  description = "(Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2."
  default     = "StorageV2"
}

variable "account_tier" {
  type        = string
  description = "(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created."
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa."
  default     = "LRS"
}

variable "cross_tenant_replication_enabled" {
  type        = bool
  description = "(Optional) Should cross Tenant replication be enabled? Defaults to false."
  default     = false
}

variable "access_tier" {
  type        = string
  description = "(Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
  default     = "Hot"
}

variable "edge_zone" {
  type        = string
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Storage Account should exist. Changing this forces a new Storage Account to be created."
  default     = null
}

variable "https_traffic_only_enabled" {
  type        = bool
  description = "(Optional) Boolean flag which forces HTTPS if enabled, see here for more information. Defaults to true."
  default     = true
}

variable "min_tls_version" {
  type        = string
  description = "(Optional) The minimum supported TLS version for the storage account. Possible values are TLS1_0, TLS1_1, and TLS1_2. Defaults to TLS1_2 for new storage accounts."
  default     = "TLS1_2"
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  description = "(Optional) Allow or disallow nested items within this Account to opt into being public. Defaults to true."
  default     = true
}

variable "shared_access_key_enabled" {
  type        = bool
  description = "(Optional) Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). Defaults to true."
  default     = true
}

variable "public_network_access_enabled" {
  type        = bool
  description = "(Optional) Whether the public network access is enabled? Defaults to true."
  default     = true
}

variable "default_to_oauth_authentication" {
  type        = bool
  description = "(Optional) Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account. The default value is false"
  default     = false
}

variable "is_hns_enabled" {
  type        = bool
  description = "(Optional) Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2 (see here for more information). Changing this forces a new resource to be created."
  default     = false
}

variable "nfsv3_enabled" {
  type        = bool
  description = "(Optional) Is NFSv3 protocol enabled? Changing this forces a new resource to be created. Defaults to false."
  default     = false
}

variable "large_file_share_enabled" {
  type        = bool
  description = "(Optional) Are Large File Shares Enabled? Defaults to false."
  default     = false
}

variable "local_user_enabled" {
  type        = bool
  description = "(Optional) Is Local User Enabled? Defaults to true."
  default     = true
}

variable "queue_encryption_key_type" {
  type        = string
  description = "(Optional) The encryption type of the queue service. Possible values are Service and Account. Changing this forces a new resource to be created. Default value is Service."
  default     = "Service"
}

variable "table_encryption_key_type" {
  type        = string
  description = "(Optional) The encryption type of the table service. Possible values are Service and Account. Changing this forces a new resource to be created. Default value is Service."
  default     = "Service"
}

variable "infrastructure_encryption_enabled" {
  type        = bool
  description = "(Optional) Is infrastructure encryption enabled? Changing this forces a new resource to be created. Defaults to false."
  default     = false
}

variable "allowed_copy_scope" {
  type        = string
  description = "(Optional) Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet. Possible values are AAD and PrivateLink."
  default     = null
}

variable "sftp_enabled" {
  type        = bool
  description = "(Optional) Boolean, enable SFTP for the storage account"
  default     = false
}

variable "dns_endpoint_type" {
  type        = string
  description = "(Optional) Specifies which DNS endpoint type to use. Possible values are Standard and AzureDnsZone. Defaults to Standard. Changing this forces a new resource to be created."
  default     = "Standard"
}


variable "custom_domain" {
  type = object({
    name          = string
    use_subdomain = bool
  })
  description = "(Optional) A custom_domain block as defined below."
  default     = null
}

variable "customer_managed_key" {
  type = object({
    key_vault_key_id          = string
    managed_hsm_key_id        = string
    user_assigned_identity_id = string
  })
  description = "(Optional) A customer_managed_key block as defined below."
  default     = null
}
variable "identity" {
  type = object({
    type         = string
    identity_ids = list(string)
  })
  description = "(Optional) An identity block as defined below."
  default     = null
}

variable "blob_properties" {
  type = object({
    cors_rule = list(object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = number
    }))
    delete_retention_policy = object({
      days                     = number
      permanent_delete_enabled = bool
    })
    restore_policy = object({
      days = number
    })
    versioning_enabled            = bool
    change_feed_enabled           = bool
    change_feed_retention_in_days = number
    default_service_version       = string
    last_access_time_enabled      = bool
    container_delete_retention_policy = object({
      days = number
    })
  })
  description = "(Optional) A blob_properties block as defined below."
  default     = null
}

variable "queue_properties" {
  type = object({
    cors_rule = list(object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = number
    }))
    logging = object({
      delete                = bool
      read                  = bool
      version               = string
      write                 = bool
      retention_policy_days = number
    })
    minute_metrics = object({
      enabled               = bool
      version               = string
      include_apis          = bool
      retention_policy_days = number
    })
    hour_metrics = object({
      enabled               = bool
      version               = string
      include_apis          = bool
      retention_policy_days = number
    })
  })
  description = "(Optional) A queue_properties block as defined below."
  default     = null
}

variable "static_website" {
  type = object({
    index_document     = string
    error_404_document = string
  })
  description = "(Optional) A static_website block as defined below."
  default     = null
}

variable "share_properties" {
  type = object({
    cors_rule = list(object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = number
    }))
    retention_policy = object({
      days = number
    })
    smb = object({
      versions                        = list(string)
      authentication_types            = list(string)
      kerberos_ticket_encryption_type = string
      channel_encryption_type         = string
      multichannel_enabled            = bool
    })
  })
  description = "(Optional) A share_properties block as defined below."
  default     = null
}

variable "network_rules" {
  type = object({
    default_action             = string
    bypass                     = list(string)
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
    private_link_access = list(object({
      endpoint_resource_id = string
      endpoint_tenant_id   = string
    }))
  })
  description = "(Optional) A network_rules block as defined below."
  default     = null

}

variable "private_link_access" {
  type = object({
    endpoint_resource_id = string
    endpoint_tenant_id   = string
  })
  description = "(Optional) A private_link_access block as defined below."
  default     = null
}

variable "azure_files_authentication" {
  type = object({
    directory_type = string
    active_directory = object({
      domain_name         = string
      domain_guid         = string
      domain_sid          = string
      storage_sid         = string
      forest_name         = string
      netbios_domain_name = string
    })
    default_share_level_permission = string
  })
  description = "(Optional) A azure_files_authentication block as defined below."
  default     = null

}

variable "routing" {
  type = object({
    publish_internet_endpoints  = bool
    publish_microsoft_endpoints = bool
    choice                      = string
  })
  description = "(Optional) A routing block as defined below."
  default     = null

}

variable "sas_policy" {
  type = object({
    expiration_period = string
    expiration_action = string
  })
  description = "(Optional) A sas_policy block as defined below."
  default     = null
}

variable "immutability_policy" {
  type = object({
    allow_protected_append_writes = bool
    state                         = string
    period_since_creation_in_days = number
  })
  description = "(Optional) An immutability_policy block as defined below."
  default     = null

}

variable "logging" {
  type = object({
    delete                = bool
    read                  = bool
    version               = string
    write                 = bool
    retention_policy_days = number
  })
  description = "(Optional) A logging block as defined below."
  default     = null
}

variable "containers" {
  type = map(object({
    name        = string
    access_type = string
  }))
  default     = {}
  description = "List of storage containers."

}

## Private Endpoint Variables


variable "custom_network_interface_name" {
  type        = string
  description = "(Optional) The custom name of the network interface attached to the private endpoint. Changing this forces a new resource to be created."
}

variable "private_service_connection_name" {
  type        = string
  description = "(Required) Specifies the Name of the Private Service Connection. Changing this forces a new resource to be created."
}

variable "private_service_connection_is_manual_connection" {
  type        = bool
  description = "(Optional) Specifies whether the connection is manual or automatic. Defaults to false."
}

variable "private_service_connection_private_connection_resource_alias" {
  type        = string
  description = "(Optional) Specifies the Alias of the Private Connection Resource to connect to."
  default = null
}

variable "private_service_connection_subresource_names" {
  type        = list(string)
  description = "(Optional) Specifies the list of Subresource Names to include within the private_service_connection."
}

variable "private_service_connection_request_message" {
  type        = string
  description = "(Optional) Specifies the Request Message to include within the private_service_connection."
}

variable "ip_configuration_name" {
  type        = string
  description = "(Required) Specifies the Name of the IP Configuration. Changing this forces a new resource to be created."
  default     = null
}

variable "ip_configuration_private_ip_address" {
  type        = string
  description = "(Optional) Specifies the Private IP Address to include within the ip_configuration."
  default     = null
}

variable "ip_configuration_subresource_name" {
  type        = string
  description = "(Optional) Specifies the Subresource Name to include within the ip_configuration."
  default     = null
}

variable "ip_configuration_member_name" {
  type        = string
  description = "(Optional) Specifies the Member Name to include within the ip_configuration."
  default     = null
}

variable "private_dns_zone_group_name" {
  type        = string
  description = "(Required) Specifies the Name of the Private DNS Zone Group. Changing this forces a new resource to be created."
}


variable "domain_name" {
  type = string
  description = "(Optional) Specifies the Domain Name that should be used for the Private DNS Zone. Changing this forces a new resource to be created."
}

## Azure ML Variables

variable "ml_ws_public_network_access_enabled" {
  type        = bool
  description = "value of the public network access enabled"
}

variable "image_build_compute_name" {
  type        = string
  description = "value of the image build compute name"
}

variable "description" {
  type        = string
  description = "value of the description"
}

variable "friendly_name" {
  type        = string
  description = "value of the friendly name"
}

variable "high_business_impact" {
  type        = bool
  description = "value of the high business impact"
}

variable "v1_legacy_mode_enabled" {
  type        = bool
  description = "value of the v1 legacy mode enabled"
}

variable "sku_name" {
  type        = string
  description = "value of the sku name"
}

variable "managed_network_isolation_mode" {
  type        = string
  description = "value of the managed network isolation mode"
  default = null
}
variable "serverless_compute_subnet_id" {
  type        = string
  description = "value of the serverless compute subnet id"
  default = null
}

variable "serverless_compute_public_ip_enabled" {
  type        = bool
  description = "value of the serverless compute public ip enabled"
  default = null
}

variable "feature_store_computer_spark_runtime_version" {
  type        = string
  description = "value of the feature store computer spark runtime version"
  default = null
}

variable "feature_store_offline_connection_name" {
  type        = string
  description = "value of the feature store offline connection name"
   default = null
}

variable "feature_store_online_connection_name" {
  type        = string
  description = "value of the feature store online connection name"
  default = null
}

variable "ml_ws_kind" {
  type        = string
  description = "value of the ml ws kind"
  default = "Default"
}

variable "container_registry_id" {
  type        = string
  description = "value of the container registry id"
  default = null
  
}


# Application Insights variables


variable "application_type" {
  type        = string
  description = "Specifies the type of Application Insights to create. Valid values are ios for iOS, java for Java web, MobileCenter for App Center, Node.JS for Node.js, other for General, phone for Windows Phone, store for Windows Store and web for ASP.NET. Please note these values are case sensitive; unmatched values are treated as ASP.NET by Azure."
}

variable "daily_data_cap_in_gb" {
  type        = number
  description = "(optional) Specifies the Application Insights component daily data volume cap in GB. Defaults to 100."
}

variable "daily_data_cap_notifications_disabled" {
  type        = bool
  description = "(optional) Specifies if a notification email will be sent when the daily data volume cap is met. Defaults to false."
}

variable "retention_in_days" {
  type        = number
  description = "(optional) Specifies the retention period in days. Possible values are 30, 60, 90, 120, 180, 270, 365, 550 or 730. Defaults to 90."
}

variable "sampling_percentage" {
  type        = number
  description = "(optional) Specifies the percentage of the data produced by the monitored application that is sampled for Application Insights telemetry. Defaults to 100."
}

variable "disable_ip_masking" {
  type        = bool
  description = "(optional) By default the real client IP is masked as 0.0.0.0 in the logs. Use this argument to disable masking and log the real client IP. Defaults to false."
}

variable "local_authentication_disabled" {
  type        = bool
  description = "(optional) Disable Non-Azure AD based Auth. Defaults to false."
}

variable "internet_ingestion_enabled" {
  type        = bool
  description = "(optional) Should the Application Insights component support ingestion over the Public Internet? Defaults to true."
}

variable "internet_query_enabled" {
  type        = bool
  description = "(optional) Should the Application Insights component support querying over the Public Internet? Defaults to true."
}

variable "force_customer_storage_for_profiler" {
  type        = bool
  description = "(optional) Should the Application Insights component force users to create their own storage account for profiling? Defaults to false."
}


## LAW Variables


variable "allow_resource_only_permissions" {
  type        = bool
  description = "(optional) describe your variable"
}



variable "sku" {
  type        = string
  description = "(optional) describe your variable"
}



variable "daily_quota_gb" {
  type        = number
  description = "(optional) describe your variable"
}

variable "cmk_for_query_forced" {
  type        = bool
  description = "(optional) describe your variable"
}

variable "reservation_capacity_in_gb_per_day" {
  type        = number
  description = "(optional) describe your variable"
}

variable "data_collection_rule_id" {
  type        = string
  description = "(optional) describe your variable"
}

variable "immediate_data_purge_on_30_days_enabled" {
  type        = bool
  description = "(optional) describe your variable"
}

variable "identity_type" {
  type = string
}

variable "identity_identity_ids" {
  type = list(string)
}


# Azure Virtual Network Peering Variables

variable "allow_virtual_network_access" {
  type        = bool
  description = "(Optional) Allow virtual network access from the remote virtual network. Defaults to true."
}

variable "allow_forwarded_traffic" {
  type        = bool
  description = "(Optional) Allow forwarded traffic from the remote virtual network. Defaults to false."
}

variable "allow_gateway_transit" {
  type        = bool
  description = "(Optional) Allow gateway transit for the remote virtual network. Defaults to false."
}

variable "use_remote_gateways" {
  type        = bool
  description = "(Optional) Allow remote gateways for the remote virtual network. Defaults to false."
}

variable "local_subnet_names" {
  type        = list(string)
  description = "(Optional) List of local subnet names to be peered with the remote virtual network."
}

variable "remote_subnet_names" {
  type        = list(string)
  description = "(Optional) List of remote subnet names to be peered with the local virtual network."
}

variable "only_ipv6_peering_enabled" {
  type        = bool
  description = "(Optional) Enable IPv6 peering only. Defaults to false."
}


