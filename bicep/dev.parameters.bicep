@description('The prefix to use for all resources')
param prefixName string = 'moneyGlob'

@description('The prefix to use for all resources')
param envName string = 'dev'

@description('The location for all resources')
param location string = resourceGroup().location

@description('The name of the Function App')
param functionAppName string = '${toLower(prefixName)}-${toLower(envName)}-${uniqueString(resourceGroup().id)}-func'

@description('The name of the Storage Account')
param storageAccountName string = '${toLower(prefixName)}${toLower(envName)}sa'

@description('The name of the App Service Plan')
param appServicePlanName string = '${toLower(prefixName)}-${toLower(envName)}-${uniqueString(resourceGroup().id)}-asp'

@description('The name of the Application Insights')
param appInsightsName string = '${toLower(prefixName)}-${toLower(envName)}-${uniqueString(resourceGroup().id)}-ai'

@description('The tags to apply to all resources')
param tags object = {
  Environment: '${envName}'
  Project: 'MoneyGlobProject'
  Owner: 'MoneyGlob'
  Department: 'IT'
}

@description('The names of the Blob Storage Containers')
param blobStorageContainerNames array = [ 'moneyglobpiccontainer' ]

@description('The names of the Table Storage Tables')
param tableStorageNames array = [ 'moneyglobpricedatatable' ]

@description('The names of the Queue Storage Queues')
param queueStorageNames array = [ 'moneyglobpricedataqueue' ]
