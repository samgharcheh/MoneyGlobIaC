using './main.bicep'

param prefixName = 'moneyGlob'
param envName = 'dev'
param tags = {
  Environment: '${envName}'
  Project: 'MoneyGlobProject'
  Owner: 'MoneyGlob'
  Department: 'IT'
}
param blobStorageContainerNames = ['moneyglobpiccontainer']
param tableStorageNames = ['moneyglobpricedatatable']
param queueStorageNames = ['moneyglobpricedataqueue' ]

