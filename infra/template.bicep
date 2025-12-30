param workspaces_synapse_retail_project_name string = 'synapse-retail-project'
param storageAccounts_retaildatalaketest_name string = 'retaildatalaketest'

resource storageAccounts_retaildatalaketest_name_resource 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccounts_retaildatalaketest_name
  location: 'westeurope'
  sku: {
    name: 'Standard_LRS'
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

resource storageAccounts_retaildatalaketest_blobService 'Microsoft.Storage/storageAccounts/blobServices@2025-01-01' = {
  parent: storageAccounts_retaildatalaketest_name_resource
  name: 'default'
  properties: {
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
  }
}

resource retail_container 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-01-01' = {
  parent: storageAccounts_retaildatalaketest_blobService
  name: 'retail'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}

resource workspaces_synapse_retail_project 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: workspaces_synapse_retail_project_name
  location: 'northeurope'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      resourceId: storageAccounts_retaildatalaketest_name_resource.id
      createManagedPrivateEndpoint: false
      accountUrl: 'https://${storageAccounts_retaildatalaketest_name}.dfs.${environment().suffixes.storage}'
      filesystem: 'retail'
    }
    managedResourceGroupName: 'synapseworkspace-managedrg-${uniqueString(resourceGroup().id)}'
    sqlAdministratorLogin: 'sqladminuser'
    publicNetworkAccess: 'Enabled'
    trustedServiceBypassEnabled: false
    workspaceRepositoryConfiguration: {
      type: 'WorkspaceGitHubConfiguration'
      accountName: 'amar212b'
      repositoryName: 'azure-project1-retail-lakehouse'
      collaborationBranch: 'main'
      rootFolder: '/synapse/'
      hostName: 'https://github.com'
    }
  }
}

resource sparkretail 'Microsoft.Synapse/workspaces/bigDataPools@2021-06-01' = {
  parent: workspaces_synapse_retail_project
  name: 'sparkretail'
  location: 'northeurope'
  properties: {
    sparkVersion: '3.5'
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
  }
}

resource allowAllFirewall 'Microsoft.Synapse/workspaces/firewallRules@2021-06-01' = {
  parent: workspaces_synapse_retail_project
  name: 'allowAll'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}
