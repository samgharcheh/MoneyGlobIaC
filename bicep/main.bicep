param prefixName string = 'moneyGlob'
param envName string = 'dev'
param location string = resourceGroup().location
param functionAppName string = '${toLower(prefixName)}-${toLower(envName)}-${uniqueString(resourceGroup().id)}-func'
param storageAccountName string = '${toLower(prefixName)}${toLower(envName)}sa'
param appServicePlanName string = '${toLower(prefixName)}-${toLower(envName)}-${uniqueString(resourceGroup().id)}-asp'

// Storage Account for Function App
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
  }
}

// Blob Service
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  name: 'default'
  parent: storageAccount
}

// Blob Storage Container
resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: 'moneyGlob-pic-container'
  parent: blobService
  properties: {
    publicAccess: 'None'
  }
}

// Table Service
resource tableService 'Microsoft.Storage/storageAccounts/tableServices@2022-05-01' = {
  name: 'default'
  parent: storageAccount
}

// Table Storage
resource TableStorage 'Microsoft.Storage/storageAccounts/tableServices/tables@2022-05-01' = {
  name: 'moneyglob-price-data-queue'
  parent: tableService
}

// Queue Service
resource queueService 'Microsoft.Storage/storageAccounts/queueServices@2022-05-01' = {
  name: 'default'
  parent: storageAccount
}

// Queue Storage  (Optional)
resource QueueStorage 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-05-01' = {
  name: 'moneyglob-price-data'
  parent: queueService
}

// App Service Plan (Linux)
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'Y1' // Consumption plan
    tier: 'Dynamic'
  }
  kind: 'linux'
  properties: {
    reserved: true // Required for Linux
  }
}

// Function App
resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp,linux'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNET-ISOLATED|8.0'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet-isolated'
        }
      ]
    }
  }
}
