param appServicePlanId string
param webAppName string
param location string
param eventGridTopicEndpoint string


@description('This is the built-in Event Grid Data Sender role. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#eventgrid-data-sender')
resource eventGridDataSenderRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: 'd5a91429-5739-47e2-a06b-3470a27159e7'
}

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


resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: webApp
  name: guid(webApp.id, eventGridDataSenderRoleDefinition.id)
  properties: {
    roleDefinitionId: eventGridDataSenderRoleDefinition.id
    principalId: webApp.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

output principalId string = webApp.identity.principalId

