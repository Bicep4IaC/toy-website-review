param location string = resourceGroup().location
param appServiceAppName string = 'toylaunch${uniqueString(resourceGroup().id)}'
@allowed(['nonprod', 'prod'])
param environmentType string
param storageAccountName string
param processOrderQueueName string

var appServicePlanName = 'toyLaunchPlan'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2V3' : 'F1'
var appServicePlanTierName = (environmentType == 'prod') ? 'PremiumV3' : 'Free'

resource appServicePlan 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
    tier: appServicePlanTierName
  }  
}

resource appServiceApp 'Microsoft.Web/sites@2025-03-01' = {
  name: appServiceAppName   //중복되지 않는 고유한 이름 입력
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'StorageAccountName'
          value: storageAccountName
        } 
        {
          name: 'ProcessOrderQueueName'
          value: processOrderQueueName
        }
      ]
    }
  }   
}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName
