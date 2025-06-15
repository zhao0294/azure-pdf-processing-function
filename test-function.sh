#!/bin/bash

echo "Waiting for deployment to complete and testing Function..."

RESOURCE_GROUP="rg-testlab2-prod"
FUNCTION_APP="func-vyixfxj6xpmrm"

# Wait for deployment to complete
echo "Waiting 30 seconds for deployment to complete..."
sleep 30

# Check function status
echo "Checking function status..."
az functionapp function show \
  --name $FUNCTION_APP \
  --resource-group $RESOURCE_GROUP \
  --function-name function_app \
  --query "{Name:name,Language:language,IsDisabled:isDisabled}" \
  --output table

echo ""
echo "Fix completed! Now please:"
echo "1. Upload a PDF file to Storage Account 'input' container"
echo "2. Wait a few minutes"
echo "3. Check 'output' container for processing results"
echo ""
echo "You can view real-time logs in Azure Portal:"
echo "Function App -> Functions -> function_app -> Monitor" 