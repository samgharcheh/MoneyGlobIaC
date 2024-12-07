param prefixName string = 'moneyGlob'
param envName string = 'dev'
param location string = resourceGroup().location
param functionAppName string = '${toLower(prefixName)}-${toLower(envName)}-${uniqueString(resourceGroup().id)}-func'
param storageAccountName string = '${toLower(prefixName)}-${toLower(envName)}-xyzt-sa'
param appServicePlanName string = '${toLower(prefixName)}-${toLower(envName)}-${uniqueString(resourceGroup().id)}-asp'

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

// // Storage Account for Function App
// resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
//   name: storageAccountName
//   location: location
//   sku: {
//     name: 'Standard_LRS'
//   }
//   kind: 'StorageV2'
//   properties: {
//     supportsHttpsTrafficOnly: true
//     minimumTlsVersion: 'TLS1_2'
//   }
// }

// // App Service Plan (Linux)
// resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
//   name: appServicePlanName
//   location: location
//   sku: {
//     name: 'Y1' // Consumption plan
//     tier: 'Dynamic'
//   }
//   kind: 'linux'
//   properties: {
//     reserved: true // Required for Linux
//   }
// }

// // Function App
// resource functionApp 'Microsoft.Web/sites@2023-01-01' = {
//   name: functionAppName
//   location: location
//   kind: 'functionapp,linux'
//   properties: {
//     serverFarmId: appServicePlan.id
//     siteConfig: {
//       linuxFxVersion: 'DOTNET-ISOLATED|8.0'
//       appSettings: [
//         {
//           name: 'AzureWebJobsStorage'
//           value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
//         }
//         {
//           name: 'FUNCTIONS_EXTENSION_VERSION'
//           value: '~4'
//         }
//         {
//           name: 'FUNCTIONS_WORKER_RUNTIME'
//           value: 'dotnet-isolated'
//         }
//         {
//           name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
//           value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
//         }
//         {
//           name: 'WEBSITE_CONTENTSHARE'
//           value: toLower(functionAppName)
//         }
//       ]
//       ftpsState: 'Disabled'
//       minTlsVersion: '1.2'
//     }
//     httpsOnly: true
//   }
// }

// output functionAppHostName string = functionApp.properties.defaultHostName
