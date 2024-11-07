param location string
param ownerName string
param storageAccountName string
param functionAppName string
param appInsightsName string
param keyVaultName string
param secretName string

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

resource functionApp 'Microsoft.Web/sites@2024-04-01' = {
  name: prefixedFunctionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: 'Consumption'
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: storageAccount.properties.primaryEndpoints.blob
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
  }
}
