param location string = resourceGroup().location
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
param appServiceAppName string = 'toylaunch${uniqueString(resourceGroup().id)}'
@allowed(['nonprod', 'prod'])
param environmentType string

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-06-01' = {
  name: storageAccountName    //중복되지 않는 고유한 이름 입력
  location: location
  sku: {
    name: storageAccountSkuName
  }  
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  } 
}

module appService 'modules/appService.bicep' = {
  name: 'appServiceDeploy'
  params: {
    appServiceAppName: appServiceAppName
    environmentType: environmentType 
    location: location
  } 
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
