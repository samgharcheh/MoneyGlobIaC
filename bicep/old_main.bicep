param location string
param ownerName string
param storageAccountName string
param functionAppName string
param appInsightsName string
param keyVaultName string
param secretName string
param hostingPlanName string

var prefixedStorageAccountName = '${ownerName}${storageAccountName}'
var prefixedFunctionAppName = '${ownerName}${functionAppName}'
var prefixedAppInsightsName = '${ownerName}${appInsightsName}'
var prefixedKeyVaultName = '${ownerName}${keyVaultName}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: prefixedStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource queueService 'Microsoft.Storage/storageAccounts/queueServices@2023-05-01' = {
  parent: storageAccount
  name: 'default'
}

resource storageQueue 'Microsoft.Storage/storageAccounts/queueServices/queues@2023-05-01' = {
  parent: queueService
  name: 'myqueue'
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: prefixedAppInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: prefixedKeyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
  }
}

// Add hosting plan resource (required for isolated process)
resource hostingPlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: '${ownerName}${hostingPlanName}'
  location: location
  sku: {
    name: 'Y1' // Y1 is for Consumption plan. Use other SKUs like P1v3 for Premium
    tier: 'Dynamic'
  }
  properties: {
    reserved: true // Required for Linux
  }
}

// Update the function app resource
resource functionApp 'Microsoft.Web/sites@2023-01-01' = {
  name: prefixedFunctionAppName
  location: location
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNET-ISOLATED|8.0'
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: true
      functionAppScaleLimit: 200
      minimumElasticInstanceCount: 0
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet-isolated'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(prefixedFunctionAppName)
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name: 'NEW_ENV_VARIABLE'
          value: '@Microsoft.KeyVault(SecretUri=https://${prefixedKeyVaultName}.vault.azure.net/secrets/${secretName})'
        }
      ]
    }
    httpsOnly: true
  }
}
