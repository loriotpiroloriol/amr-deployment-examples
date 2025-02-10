targetScope = 'resourceGroup'

// Parameters
@description('Required. Azure location to which the resources are to be deployed')
param location string

@description('Required. Application name')
param applicationName string

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

var resourceNames = {
  keyVault: 'kv-${applicationName}'
}

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: resourceNames.keyVault
  location: location
  tags: tags
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    enabledForTemplateDeployment: true // ARM is permitted to retrieve secrets from the key vault. 
    accessPolicies: []
  }
}

// Outputs
output keyVaultName string = keyVault.name
