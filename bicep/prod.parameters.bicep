param functionAppName string = 'moneyGlob-afa-640-prod'
param storageAccountName string = 'moneyGlob-asto-640-prod'
param appServicePlanName string = 'moneyGlob-asplan-640-prod'

@description('Location for all resources.')
param location string = 'eastus'

@description('Owner of the resources.')
param ownerName string = 'prodOwner'

@description('Name of the resource group.')
param resourceGroupName string = 'prodResourceGroup'

@description('Name of the storage account.')
param storageAccountName string = 'prodstorageaccount'

@description('Name of the function app.')
param functionAppName string = 'prodfunctionapp'

@description('Name of the Application Insights resource.')
param appInsightsName string = 'prodappinsights'

@description('Name of the Key Vault.')
param keyVaultName string = 'prodkeyvault'

@description('Name of the secret in Key Vault.')
param secretName string = 'prodSecret'

@description('Name of the hosting plan.')
param hostingPlanName string = 'prodhostingplan'

@description('Tags for the resources.')
param tags object = {
  Environment: 'prod'
  Project: 'MoneyGlobProject'
  Owner: 'MoneyGlob'
  Department: 'IT'
}
