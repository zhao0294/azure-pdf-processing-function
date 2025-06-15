#!/bin/bash

echo "Starting clean and redeploy function..."

RESOURCE_GROUP="rg-testlab2-prod"
FUNCTION_APP="func-vyixfxj6xpmrm"

# 1. Stop Function App
echo "Stopping Function App..."
az functionapp stop --name $FUNCTION_APP --resource-group $RESOURCE_GROUP

# 2. Delete all application files
echo "Cleaning application files..."
az functionapp deployment source delete --name $FUNCTION_APP --resource-group $RESOURCE_GROUP 2>/dev/null || echo "No deployment source to delete"

# 3. Restart Function App
echo "Restarting Function App..."
az functionapp start --name $FUNCTION_APP --resource-group $RESOURCE_GROUP

# 4. Wait 3 seconds
echo "Waiting for Function App to start..."
sleep 3

# 5. Redeploy using func CLI
echo "Redeploying function code..."
func azure functionapp publish $FUNCTION_APP --force

echo "Deployment completed! Wait a few minutes for Function to fully reload, then test uploading PDF files." 