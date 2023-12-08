param subscriptionId string
param resourceGroupName string
param streamingJobName string
param clientId string
param clientSecret string
param tenantId string

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: 'logicAppName'
  location: resourceGroup().location
  properties: {
    definition: {
      $schema: 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      actions: {
        installSDK: {
          type: 'Execute a command or script'
          inputs: {
            script: 'npm install azure-arm-streamanalytics'
          }
          outputs: []
        }
        authenticate: {
          type: 'Execute a command or script'
          inputs: {
            script: '
              const msRestAzure = require("ms-rest-azure");
              async function authenticate() {
                const clientId = "' + clientId + '";
                const secret = "' + clientSecret + '";
                const domain = "' + tenantId + '";
                const credentials = await msRestAzure.loginWithServicePrincipalSecret(clientId, secret, domain);
                return credentials;
              }
              module.exports = authenticate;
            '
          }
          outputs: [
            'outputs'
          ]
        }
        stopStreamAnalyticsJob: {
          type: 'Execute a command or script'
          inputs: {
            script: '
              const streamAnalyticsManagement = require("azure-arm-streamanalytics");
              async function stopStreamAnalyticsJob(credentials, subscriptionId, resourceGroupName, streamingJobName) {
                const client = new streamAnalyticsManagement(credentials, subscriptionId);
                await client.streamingJobs.stop(resourceGroupName, streamingJobName);
              }
              module.exports = stopStreamAnalyticsJob;
            '
            parameters: {
              'credentials': '@outputs('authenticate').outputs',
              'subscriptionId': subscriptionId,
              'resourceGroupName': resourceGroupName,
              'streamingJobName': streamingJobName
            }
          }
          outputs: []
        }
      }
      triggers: {
        schedule: {
          type: 'Recurrence'
          inputs: {
            frequency: 'Day'
            interval: 1
            startTime: '17:00:00'
            timeZone: 'UTC'
          }
          outputs: []
          metadata: {
            flowTrigger: 'true'
          }
        }
      }
    }
  }
}
