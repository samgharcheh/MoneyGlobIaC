using './main.bicep'

param prefixName = 'moneyGlob'
param envName = 'dev'
param location = 'eastus'
param functionAppName = '${toLower(prefixName)}-${toLower(envName)}-${uniqueString(location)}-func'
param storageAccountName = '${toLower(prefixName)}${toLower(envName)}${uniqueString(location)}'
param appServicePlanName = '${toLower(prefixName)}-${toLower(envName)}-${uniqueString(location)}-asp'
param appInsightsName = '${toLower(prefixName)}-${toLower(envName)}-${uniqueString(location)}-ai'
param tags = {
  Environment: '${envName}'
  Project: 'MoneyGlobProject'
  Owner: 'MoneyGlob'
  Department: 'IT'
}
param blobStorageContainerNames = ['moneyglobpiccontainer']
param tableStorageNames = ['moneyglobpricedatatable']
param queueStorageNames = ['moneyglobpricedataqueue' ]

