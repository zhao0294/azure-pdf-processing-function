param location string
param resourceToken string
param tags object

// Storage account for Azure Functions
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'st${resourceToken}'
  location: location
  tags: tags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

// App Service Plan for Azure Functions
resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: 'plan-${resourceToken}'
  location: location
  tags: tags
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {
    reserved: true
  }
}

// Application Insights
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-${resourceToken}'
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

// Azure Functions App
resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: 'func-${resourceToken}'
  location: location
  tags: union(tags, { 'azd-service-name': 'api' })
  kind: 'functionapp,linux'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'Python|3.10'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower('func-${resourceToken}')
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~18'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsights.properties.ConnectionString
        }
        {
          name: 'COGNITIVE_SERVICES_ENDPOINT'
          value: 'https://8917lab2cs.cognitiveservices.azure.com/'
        }
        {
          name: 'COGNITIVE_SERVICES_KEY'
          value: '3nU5TuEi108P1Je8cZhbKxAlBGkVMoE1LfMZvsG2IaNZKsC1S1zcJQQJ99BFACYeBjFXJ3w3AAALACOGq35j'
        }
        {
          name: 'AZURE_OPENAI_ENDPOINT'
          value: 'https://zhao0-mbx0dspa-swedencentral.cognitiveservices.azure.com/'
        }
        {
          name: 'AZURE_OPENAI_KEY'
          value: 'TVAOcMv8Qd59zvV4ODoODPmvaAxX6MbriFSweOWPq7LpCPodzZLtJQQJ99BFACYeBjFXJ3w3AAAAACOGnrEB'
        }
        {
          name: 'CHAT_MODEL_DEPLOYMENT_NAME'
          value: 'gpt-35-turbo'
        }
      ]
    }
  }
}

// Create input and output containers in storage account
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-04-01' = {
  name: 'default'
  parent: storageAccount
}

resource inputContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: 'input'
  parent: blobService
  properties: {
    publicAccess: 'None'
  }
}

resource outputContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: 'output'
  parent: blobService
  properties: {
    publicAccess: 'None'
  }
}

// Outputs
output functionAppName string = functionApp.name
output storageAccountName string = storageAccount.name
