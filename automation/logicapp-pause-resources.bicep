targetScope = 'resourceGroup'

@description('Please specify a location')
param location string = resourceGroup().location

var powerbiembedded_name = 'powerbiembedded${uniqueString(resourceGroup().id)}'
var synapse_name = 'synapse-${uniqueString(resourceGroup().id)}'

resource powerbi_logicapp_pause_powerbi 'Microsoft.Logic/workflows@2017-07-01' = {
  name: 'logicapp-pause-powerbi-embedded'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    definition: {
      '$schema': 'https://schema.management.azure.com/schemas/2016-06-01/Microsoft.Logic.json'
      contentVersion: '1.0.0.0'
      parameters: {
        '$suspenduri': {
          type: 'String'
        }
        '$getdetailsuri': {
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
        Condition: {
          actions: {
            Suspend: {
              runAfter: {}
              type: 'Http'
              inputs: {
                authentication: {
                  type: 'ManagedServiceIdentity'
                }
                method: 'POST'
                uri: '@parameters(\'$suspenduri\')'
              }
            }
          }
          runAfter: {
            Parse_JSON: [
              'Succeeded'
            ]
          }
          expression: {
            and: [
              {
                not: {
                  equals: [
                    '@body(\'Parse_JSON\')?[\'properties\']?[\'state\']'
                    'Paused'
                  ]
                }
              }
            ]
          }
          type: 'If'
        }
        Get_Power_BI_Embedded_Capacity: {
          runAfter: {}
          type: 'Http'
          inputs: {
            authentication: {
              type: 'ManagedServiceIdentity'
            }
            method: 'GET'
            uri: '@parameters(\'$getdetailsuri\')'
          }
        }
        Parse_JSON: {
          runAfter: {
            Get_Power_BI_Embedded_Capacity: [
              'Succeeded'
            ]
          }
          type: 'ParseJson'
          inputs: {
            content: '@body(\'Get_Power_BI_Embedded_Capacity\')'
            schema: {
              properties: {
                id: {
                  type: 'string'
                }
                location: {
                  type: 'string'
                }
                name: {
                  type: 'string'
                }
                properties: {
                  properties: {
                    administration: {
                      properties: {
                        members: {
                          items: {
                            type: 'string'
                          }
                          type: 'array'
                        }
                      }
                      type: 'object'
                    }
                    mode: {
                      type: 'string'
                    }
                    provisioningState: {
                      type: 'string'
                    }
                    state: {
                      type: 'string'
                    }
                  }
                  type: 'object'
                }
                sku: {
                  properties: {
                    capacity: {
                      type: 'integer'
                    }
                    name: {
                      type: 'string'
                    }
                    tier: {
                      type: 'string'
                    }
                  }
                  type: 'object'
                }
                tags: {
                  properties: {}
                  type: 'object'
                }
                type: {
                  type: 'string'
                }
              }
              type: 'object'
            }
          }
        }
      }
      outputs: {
      }
    }
    parameters: {
      '$suspenduri': {
        type: 'String'
        value: 'https://management.azure.com/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.PowerBIDedicated/capacities/${powerbiembedded_name}/suspend?api-version=2021-01-01'
      }
      '$getdetailsuri': {
        type: 'String'
        value: 'https://management.azure.com/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.PowerBIDedicated/capacities/${powerbiembedded_name}?api-version=2021-01-01'
      }
    }
  }
}

resource id_Microsoft_Logic_workflows_powerbi_logicapp_pause_powerbi_b24988ac_6180_42a0_ab88_20f7382dd24c 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(concat(resourceGroup().id), powerbi_logicapp_pause_powerbi.id, 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // contributor
    principalId: reference(powerbi_logicapp_pause_powerbi.id, '2017-07-01', 'full').identity.principalId
    scope: resourceGroup().id
    principalType: 'ServicePrincipal'
  }
}

resource powerbi_logicapp_pause_synapse 'Microsoft.Logic/workflows@2017-07-01' = {
  name: 'logicapp-pause-synapse-dedicated'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    definition: {
      '$schema': 'https://schema.management.azure.com/schemas/2016-06-01/Microsoft.Logic.json'
      contentVersion: '1.0.0.0'
      parameters: {
        '$suspenduri': {
          type: 'String'
        }
        '$getdetailsuri': {
          type: 'String'
        }
      }
      triggers: {
        AtNight: {
          recurrence: {
            frequency: 'Week'
            interval: 1
            schedule: {
              hours: [
                '18', '20'
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
        Condition: {
          actions: {
            Suspend: {
              runAfter: {}
              type: 'Http'
              inputs: {
                authentication: {
                  type: 'ManagedServiceIdentity'
                }
                method: 'POST'
                uri: '@parameters(\'$suspenduri\')'
              }
            }
          }
          runAfter: {
            Parse_JSON: [
              'Succeeded'
            ]
          }
          expression: {
            and: [
              {
                not: {
                  equals: [
                    '@body(\'Parse_JSON\')?[\'properties\']?[\'status\']'
                    'Paused'
                  ]
                }
              }
            ]
          }
          type: 'If'
        }
        Get_SynapseDedicatedPoolState: {
          runAfter: {}
          type: 'Http'
          inputs: {
            authentication: {
              type: 'ManagedServiceIdentity'
            }
            method: 'GET'
            uri: '@parameters(\'$getdetailsuri\')'
          }
        }
        Parse_JSON: {
          runAfter: {
            Get_SynapseDedicatedPoolState: [
              'Succeeded'
            ]
          }
          type: 'ParseJson'
          inputs: {
            content: '@body(\'Get_SynapseDedicatedPoolState\')'
            schema: {
              properties: {
                id: {
                  type: 'string'
                }
                location: {
                  type: 'string'
                }
                name: {
                  type: 'string'
                }
                properties: {
                  properties: {
                    collation: {
                      type: 'string'
                    }
                    creationDate: {
                      type: 'string'
                    }
                    maxSizeBytes: {
                      type: 'integer'
                    }
                    provisioningState: {
                      type: 'string'
                    }
                    status: {
                      type: 'string'
                    }
                  }
                  type: 'object'
                }
                sku: {
                  properties: {
                    capacity: {
                      type: 'integer'
                    }
                    name: {
                      type: 'string'
                    }
                  }
                  type: 'object'
                }
                type: {
                  type: 'string'
                }
              }
              type: 'object'
            }
          }
        }
      }
      outputs: {
      }
    }
    parameters: {
      '$suspenduri': {
        type: 'String'
        value: 'https://management.azure.com/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Synapse/workspaces/${synapse_name}/sqlPools/DP500DWH/pause?api-version=2019-06-01-preview'
      }
      '$getdetailsuri': {
        type: 'String'
        value: 'https://management.azure.com/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Synapse/workspaces/${synapse_name}/sqlPools/DP500DWH?api-version=2019-06-01-preview'
      }
    }
  }
}

resource id_Microsoft_Logic_workflows_logicapp_pause_synapse_b24988ac_6180_42a0_ab88_20f7382dd24c 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(concat(resourceGroup().id), powerbi_logicapp_pause_synapse.id, 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // contributor
    principalId: reference(powerbi_logicapp_pause_synapse.id, '2017-07-01', 'full').identity.principalId
    scope: resourceGroup().id
    principalType: 'ServicePrincipal'
  }
}
