// Test trigger - safe change
@secure()
param vulnerabilityAssessments_Default_storageContainerPath string
param workspaces_synapse_retail_project_name string = 'synapse-retail-project'
param storageAccounts_retaildatalaketest_name string = 'retaildatalaketest'

resource storageAccounts_retaildatalaketest_name_resource 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccounts_retaildatalaketest_name
  location: 'westeurope'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    isSftpEnabled: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    largeFileSharesState: 'Enabled'
    isHnsEnabled: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource storageAccounts_retaildatalaketest_name_default 'Microsoft.Storage/storageAccounts/blobServices@2025-01-01' = {
  parent: storageAccounts_retaildatalaketest_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_retaildatalaketest_name_default 'Microsoft.Storage/storageAccounts/fileServices@2025-01-01' = {
  parent: storageAccounts_retaildatalaketest_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_retaildatalaketest_name_default 'Microsoft.Storage/storageAccounts/queueServices@2025-01-01' = {
  parent: storageAccounts_retaildatalaketest_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_retaildatalaketest_name_default 'Microsoft.Storage/storageAccounts/tableServices@2025-01-01' = {
  parent: storageAccounts_retaildatalaketest_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource workspaces_synapse_retail_project_name_resource 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: workspaces_synapse_retail_project_name
  location: 'northeurope'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      resourceId: storageAccounts_retaildatalaketest_name_resource.id
      createManagedPrivateEndpoint: false
      accountUrl: 'https://retaildatalaketest.dfs.core.windows.net'
      filesystem: 'retail'
    }
    encryption: {}
    managedResourceGroupName: 'synapseworkspace-managedrg-31b05c25-4b9a-4323-9989-ff4cf92b10a2'
    sqlAdministratorLogin: 'sqladminuser'
    privateEndpointConnections: []
    workspaceRepositoryConfiguration: {
      accountName: 'amar212b'
      collaborationBranch: 'main'
      hostName: 'https://github.com'
      lastCommitId: 'fc076082466ef74cf4c99e90830ea709dab9e748'
      repositoryName: 'azure-project1-retail-lakehouse'
      rootFolder: '/synapse/'
      type: 'WorkspaceGitHubConfiguration'
    }
    publicNetworkAccess: 'Enabled'
    cspWorkspaceAdminProperties: {
      initialWorkspaceAdminObjectId: '49af20c8-5a09-45ad-bc3b-02cf0f7a59f1'
    }
    azureADOnlyAuthentication: false
    trustedServiceBypassEnabled: false
  }
}

resource workspaces_synapse_retail_project_name_Default 'Microsoft.Synapse/workspaces/auditingSettings@2021-06-01' = {
  parent: workspaces_synapse_retail_project_name_resource
  name: 'Default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource Microsoft_Synapse_workspaces_azureADOnlyAuthentications_workspaces_synapse_retail_project_name_default 'Microsoft.Synapse/workspaces/azureADOnlyAuthentications@2021-06-01' = {
  parent: workspaces_synapse_retail_project_name_resource
  name: 'default'
  properties: {
    azureADOnlyAuthentication: false
  }
}

resource workspaces_synapse_retail_project_name_sparkretail 'Microsoft.Synapse/workspaces/bigDataPools@2021-06-01' = {
  parent: workspaces_synapse_retail_project_name_resource
  name: 'sparkretail'
  location: 'northeurope'
  properties: {
    sparkVersion: '3.5'
    nodeCount: 10
    nodeSize: 'Small'
    nodeSizeFamily: 'MemoryOptimized'
    autoScale: {
      enabled: true
      minNodeCount: 3
      maxNodeCount: 3
    }
    autoPause: {
      enabled: true
      delayInMinutes: 5
    }
    isComputeIsolationEnabled: false
    sessionLevelPackagesEnabled: false
    cacheSize: 50
    dynamicExecutorAllocation: {
      enabled: false
    }
    isAutotuneEnabled: false
    provisioningState: 'Succeeded'
  }
}

resource Microsoft_Synapse_workspaces_dedicatedSQLminimalTlsSettings_workspaces_synapse_retail_project_name_default 'Microsoft.Synapse/workspaces/dedicatedSQLminimalTlsSettings@2021-06-01' = {
  parent: workspaces_synapse_retail_project_name_resource
  name: 'default'
  location: 'northeurope'
  properties: {
    minimalTlsVersion: '1.2'
  }
}

resource Microsoft_Synapse_workspaces_extendedAuditingSettings_workspaces_synapse_retail_project_name_Default 'Microsoft.Synapse/workspaces/extendedAuditingSettings@2021-06-01' = {
  parent: workspaces_synapse_retail_project_name_resource
  name: 'Default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource workspaces_synapse_retail_project_name_allowAll 'Microsoft.Synapse/workspaces/firewallRules@2021-06-01' = {
  parent: workspaces_synapse_retail_project_name_resource
  name: 'allowAll'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

resource workspaces_synapse_retail_project_name_AutoResolveIntegrationRuntime 'Microsoft.Synapse/workspaces/integrationruntimes@2021-06-01' = {
  parent: workspaces_synapse_retail_project_name_resource
  name: 'AutoResolveIntegrationRuntime'
  properties: {
    type: 'Managed'
    typeProperties: {
      computeProperties: {
        location: 'AutoResolve'
      }
    }
  }
}

resource Microsoft_Synapse_workspaces_securityAlertPolicies_workspaces_synapse_retail_project_name_Default 'Microsoft.Synapse/workspaces/securityAlertPolicies@2021-06-01' = {
  parent: workspaces_synapse_retail_project_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
}

/*resource Microsoft_Synapse_workspaces_vulnerabilityAssessments_workspaces_synapse_retail_project_name_Default 'Microsoft.Synapse/workspaces/vulnerabilityAssessments@2021-06-01' = {
  parent: workspaces_synapse_retail_project_name_resource
  name: 'Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
    storageContainerPath: vulnerabilityAssessments_Default_storageContainerPath
  }
}*/

resource storageAccounts_retaildatalaketest_name_default_retail 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-01-01' = {
  parent: storageAccounts_retaildatalaketest_name_default
  name: 'retail'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_retaildatalaketest_name_resource
  ]
}
