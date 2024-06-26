@description('Azure Cosmos DB MongoDB vCore cluster name')
@maxLength(40)
param clusterName string = 'mgovs-${uniqueString(resourceGroup().id)}'

@description('Location for the cluster.')
param location string = resourceGroup().location

@description('Username for admin user')
param adminUsername string

@secure()
@description('Password for admin user')
@minLength(8)
@maxLength(128)
param adminPassword string


@description('Azure OpenAI Sku')
@allowed([
  'Free'
  'M25'
  'M30'
  'M40'
  'M50'
  'M60'
  'M80'
])
param sku string = 'M40'

resource cluster 'Microsoft.DocumentDB/mongoClusters@2024-02-15-preview' = {
  name: clusterName
  location: location
  properties: {
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
    nodeGroupSpecs: [
        {
            kind: 'Shard'
            nodeCount: 1
            sku: sku
            diskSizeGB: 32
            enableHa: false
        }
    ]
  }
}

resource firewallRules 'Microsoft.DocumentDB/mongoClusters/firewallRules@2024-02-15-preview' = {
  parent: cluster
  name: 'AllowAll'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}
