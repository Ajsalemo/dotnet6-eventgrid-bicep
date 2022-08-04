param appServicePlanId string
param webAppName string
param location string
param eventGridTopicEndpoint string
param eventGridName string

resource webApp 'Microsoft.Web/sites@2021-01-01' = {
  name: webAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enabled: true
    httpsOnly: true
    reserved: true
    clientAffinityEnabled: false
    siteConfig: {
      appSettings: [
        {
          name: 'AZURE_EVENT_GRID_TOPIC_ENDPOINT'
          value: eventGridTopicEndpoint
        }
      ]
      httpLoggingEnabled: true
      logsDirectorySizeLimit: 35
      webSocketsEnabled: false
      alwaysOn: false
      linuxFxVersion: 'DOTNETCORE|6.0'
    }
    serverFarmId: appServicePlanId
  }
}


resource eventGrid 'Microsoft.EventGrid/topics@2022-06-15' = {
  name: eventGridName
  location: location
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: eventGrid
  // This is an abitrary name
  name: guid(eventGrid.id, resourceGroup().id, subscription().id)
  properties: {
    // Role definition ID of the EventGrid Data Sender Role - /providers/Microsoft.Authorization/roleDefinitions/d5a91429-5739-47e2-a06b-3470a27159e7
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/d5a91429-5739-47e2-a06b-3470a27159e7'
    principalId: webApp.identity.principalId
    principalType: 'ServicePrincipal'
  }
}


