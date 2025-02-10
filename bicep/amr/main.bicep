targetScope = 'subscription'

@description('Optional. Azure main location to which the resources are to be deployed -defaults to the location of the current deployment')
param location string = deployment().location

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

var applicationName = 'myapplication'

var defaultTags = union({
  application: applicationName
}, tags)

var appResourceGroupName = 'rg-${applicationName}'

// Create resource groups
resource appResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: appResourceGroupName
  location: location
  tags: defaultTags
}

//Create Redis resource
module redis 'redis.bicep' = {
  scope: resourceGroup(appResourceGroup.name)
  name: 'redis-Deployment'
  params: {
    location: location
    tags: defaultTags
    applicationName: applicationName
  }
}

output appResourceGroupName string = appResourceGroup.name
