#!/bin/bash

# Set variables
RESOURCE_GROUP="rg-testlab2"
FUNCTION_APP_NAME="func-testlab2-$(date +%Y%m%d)"
STORAGE_ACCOUNT="st8917lab2sa"
LOCATION="eastus"

echo "Starting deployment to Azure..."

# 1. Create resource group (if not exists)
echo "Creating resource group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# 2. Create storage account (if not exists)
echo "Creating storage account..."
az storage account create \
  --name $STORAGE_ACCOUNT \
  --location $LOCATION \
  --resource-group $RESOURCE_GROUP \
  --sku Standard_LRS

# 3. Create Function App
echo "Creating Function App..."
az functionapp create \
  --resource-group $RESOURCE_GROUP \
  --consumption-plan-location $LOCATION \
  --runtime python \
  --runtime-version 3.10 \
  --functions-version 4 \
  --name $FUNCTION_APP_NAME \
  --storage-account $STORAGE_ACCOUNT

# 4. Configure app settings
echo "Configuring app settings..."
az functionapp config appsettings set \
  --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings \
  "COGNITIVE_SERVICES_ENDPOINT=https://8917lab2cs.cognitiveservices.azure.com/" \
  "COGNITIVE_SERVICES_KEY=3nU5TuEi108P1Je8cZhbKxAlBGkVMoE1LfMZvsG2IaNZKsC1S1zcJQQJ99BFACYeBjFXJ3w3AAALACOGq35j" \
  "AZURE_OPENAI_ENDPOINT=https://zhao0-mbx0dspa-swedencentral.cognitiveservices.azure.com/" \
  "AZURE_OPENAI_KEY=TVAOcMv8Qd59zvV4ODoODPmvaAxX6MbriFSweOWPq7LpCPodzZLtJQQJ99BFACfhMk5XJ3w3AAAAACOGnrEB" \
  "CHAT_MODEL_DEPLOYMENT_NAME=gpt-35-turbo"

# 5. Deploy function code
echo "Deploying function code..."
func azure functionapp publish $FUNCTION_APP_NAME

echo "Deployment completed!"
echo "Function App name: $FUNCTION_APP_NAME"
echo "Resource group: $RESOURCE_GROUP" 