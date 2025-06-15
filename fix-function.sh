#!/bin/bash

echo "Checking Function App configuration..."

RESOURCE_GROUP="rg-testlab2-prod"
FUNCTION_APP="func-vyixfxj6xpmrm"
STORAGE_ACCOUNT="stvyixfxj6xpmrm"

# 1. Get storage account connection string
echo "Getting storage account connection string..."
STORAGE_CONNECTION=$(az storage account show-connection-string \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --query connectionString \
  --output tsv)

echo "Storage connection string: ${STORAGE_CONNECTION:0:50}..."

# 2. Update Function App's storage connection string
echo "Updating Function App AzureWebJobsStorage setting..."
az functionapp config appsettings set \
  --name $FUNCTION_APP \
  --resource-group $RESOURCE_GROUP \
  --settings "AzureWebJobsStorage=$STORAGE_CONNECTION"

# 3. Restart Function App
echo "Restarting Function App..."
az functionapp restart --name $FUNCTION_APP --resource-group $RESOURCE_GROUP

echo "Fix completed! Please wait a few minutes for Function App to restart, then re-upload PDF file for testing."
echo ""
echo "Debug tips:"
echo "1. Make sure PDF files are uploaded directly to 'input' container root directory"
echo "2. Check Function Monitor page in Azure Portal"
echo "3. View logs in Application Insights" 