targetScope = 'resourceGroup'

@description('Please specify a location')
param location string = resourceGroup().location

@description('Please specify the Power BI capacity administrator')
param admin string

var powerbiembedded_name = 'powerbiembedded${uniqueString(resourceGroup().id)}'

resource powerbi_embedded 'Microsoft.PowerBIDedicated/capacities@2021-01-01' = {
  name: powerbiembedded_name
  location: location
  sku: {
    name: 'A4' // this A4 capacity corresponds to P1 (Premium P1). Check out https://learn.microsoft.com/en-us/power-bi/enterprise/service-admin-premium-testing
  }
  properties: {
    administration: {
      members: [
        admin
      ]
    }
    mode: 'Gen2'
  }
}


resource powerbi_logicapp_pause 'Microsoft.Logic/workflows@2017-07-01' = {
  name: 'logicapp-pause-${powerbiembedded_name}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    definition: {
      '$schema': 'https://schema.management.azure.com/schemas/2016-06-01/Microsoft.Logic.json'
      contentVersion: '1.0.0.0'
      parameters: {
        '$uri': {
          type: 'String'
        }
      }
      triggers: {
        Every_2_hours: {
          recurrence: {
            frequency: 'Week'
            interval: 1
            schedule: {
              hours: [
                '10', '12', '14', '16', '18', '20'
              ]
              minutes: [
                0
              ]
              weekDays: [
                'Monday'
                'Tuesday'
                'Wednesday'
                'Thursday'
                'Friday'
              ]
            }
            timeZone: 'Romance Standard Time'
          }
          type: 'Recurrence'
        }
      }
      actions: {
        HTTP: {
          inputs: {
            authentication: {
              type: 'ManagedServiceIdentity'
            }
            method: 'POST'
            uri: '@parameters(\'$uri\')'
          }
          runAfter: {
          }
          type: 'Http'
        }
      }
      outputs: {
      }
    }
    parameters: {
      '$uri': {
        type: 'String'
        value: 'https://management.azure.com/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.PowerBIDedicated/capacities/${powerbiembedded_name}/suspend?api-version=2021-01-01'
      }
    }
  }
  dependsOn: [
    powerbi_embedded
  ]
}

resource id_Microsoft_Logic_workflows_powerbi_logicapp_pause_b24988ac_6180_42a0_ab88_20f7382dd24c 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(concat(resourceGroup().id), powerbi_logicapp_pause.id, 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // contributor
    principalId: reference(powerbi_logicapp_pause.id, '2017-07-01', 'full').identity.principalId
    scope: resourceGroup().id
    principalType: 'ServicePrincipal'
  }
  dependsOn: [
    powerbi_embedded
  ]
}
