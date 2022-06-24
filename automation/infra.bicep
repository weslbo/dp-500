targetScope = 'resourceGroup'

@description('Please specify a username for the SQL Server administrator (default "azureuser")')
param sqlAdministratorLogin string = 'azureuser'

@secure()
@description('Please specify a password for the SQL Server administrator')
param sqlAdministratorLoginPassword string

@description('Please specify a location')
param location string = resourceGroup().location

@description('The name of the Bastion public IP address')
param publicIpName string = 'bastion-pip'

@description('The name of the Bastion host')
param bastionHostName string = 'bastion-jumpbox'

resource vnet 'Microsoft.Network/virtualNetworks@2020-07-01' = {
  name: 'vnet-dp-500'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'PowerBISubnet'
        properties: {
          addressPrefix: '10.10.0.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
          ]
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.10.1.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
      {
        name: 'DatabaseSubnet'
        properties: {
          addressPrefix: '10.10.2.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
          ]
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
  }
}

resource publicIpAddressForBastion 'Microsoft.Network/publicIpAddresses@2020-08-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2020-06-01' = {
  name: bastionHostName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: '${vnet.id}/subnets/AzureBastionSubnet'
          }
          publicIPAddress: {
            id: publicIpAddressForBastion.id
          }
        }
      }
    ]
  }
}


resource vm_powerbi 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: 'vm-powerbi'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D8s_v3'
    }
    storageProfile: {
      osDisk: {
        name: 'vm-powerbi-disk-os'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      imageReference: {
        publisher: 'microsoftvisualstudio'
        offer: 'visualstudio2022'
        sku: 'vs-2022-ent-latest-win11-n'
        version: 'latest'
      }
      dataDisks: [
        {
          name: 'vm-powerbi-disk-data'
          lun: 0
          createOption: 'Empty'
          diskSizeGB: 1023
          managedDisk: {
            storageAccountType: 'Premium_LRS'
          }
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vm_powerbi_networkInterface.id
        }
      ]
    }
    osProfile: {
      computerName: 'vm-powerbi'
      adminUsername: sqlAdministratorLogin
      adminPassword: sqlAdministratorLoginPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
        }
      }
    }
    licenseType: 'Windows_Client'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }

  resource vm_dev_script_extension_choco 'extensions@2018-06-01' = {
    name: 'choco'
    location: location
    properties: {
      publisher: 'Microsoft.Compute'
      type: 'CustomScriptExtension'
      typeHandlerVersion: '1.10'
      autoUpgradeMinorVersion: true
      settings: {
        fileUris: [
          'https://raw.githubusercontent.com/weslbo/dp-500/main/automation/vm-powerbi.ps1'
        ]
      }
      protectedSettings: {
        commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File ./vm-powerbi.ps1'
      }
    }
  }
}

resource vm_powerbi_networkInterface 'Microsoft.Network/networkInterfaces@2018-10-01' = {
  name: 'vm-powerbi-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${vnet.id}/subnets/PowerBISubnet'
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource vm_powerbi_shutdown_name 'Microsoft.DevTestLab/schedules@2018-09-15' = {
  name: 'shutdown-computevm-${vm_powerbi.name}'
  location: location
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '1800'
    }
    timeZoneId: 'Central Europe Standard Time'
    notificationSettings: {
      status: 'Disabled'
      timeInMinutes: 30
    }
    targetResourceId: vm_powerbi.id
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'managed-identity'
  location: location
}


resource nsg 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: 'nsg-vnet-dp-500'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowGatewayManager'
        properties: {
          description: 'Allow GatewayManager'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'GatewayManager'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 2702
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowHttpsInBound'
        properties: {
          description: 'Allow HTTPs'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 2703
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowSshRdpOutbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: [
            '22'
            '3389'
          ]
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowAzureCloudOutbound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'AzureCloud'
          access: 'Allow'
          priority: 110
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkwatcher 'Microsoft.Network/networkWatchers@2020-11-01' = {
  name: 'NetworkWatcher_${location}'
  location: location
  properties: {}
}

resource vm_sqlserver 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: 'vm-sqlserver'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D8s_v3'
    }
    storageProfile: {
      osDisk: {
        name: 'vm-sqlserver-disk-os'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      imageReference: {
        publisher: 'MicrosoftSQLServer'
        offer: 'sql2019-ws2019'
        sku: 'sqldev'
        version: 'latest'
      }
      dataDisks: [
        {
          name: 'vm-sqlserver-disk-data'
          lun: 0
          createOption: 'Empty'
          diskSizeGB: 1023
          managedDisk: {
            storageAccountType: 'Premium_LRS'
          }
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vm_sqlserver_networkInterface.id
        }
      ]
    }
    osProfile: {
      computerName: 'vm-sqlserver'
      adminUsername: sqlAdministratorLogin
      adminPassword: sqlAdministratorLoginPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
        }
      }
    }
    licenseType: 'Windows_Client'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
}

resource vm_sqlserver_networkInterface 'Microsoft.Network/networkInterfaces@2018-10-01' = {
  name: 'vm-sqlserver-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${vnet.id}/subnets/DatabaseSubnet'
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource vm_sqlserver_shutdown_name 'Microsoft.DevTestLab/schedules@2018-09-15' = {
  name: 'shutdown-computevm-${vm_sqlserver.name}'
  location: location
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '1800'
    }
    timeZoneId: 'Central Europe Standard Time'
    notificationSettings: {
      status: 'Disabled'
      timeInMinutes: 30
    }
    targetResourceId: vm_sqlserver.id
  }
}
