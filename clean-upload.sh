#!/bin/bash

# Clean GitHub Upload Script (No Sensitive Data)
echo "🧹 Starting clean GitHub upload..."

# Remove existing Git repository to start fresh
echo "🗑️ Removing existing Git history..."
rm -rf .git

# Initialize new repository
echo "📦 Initializing fresh Git repository..."
git init

# Configure Git user
echo "👤 Configuring Git user..."
git config user.name "zhao0294"
git config user.email "zhao0294@algonquinlive.com"

# Add only safe files (exclude local.settings.json)
echo "📁 Adding safe files only..."
git add README.md
git add requirements.txt
git add host.json
git add azure.yaml
git add function_app/
git add .gitignore
git add local.settings.json.example
git add *.sh

# Create clean commit
echo "💾 Creating clean commit..."
git commit -m "Initial commit: Azure PDF Processing Function

🚀 Serverless PDF processing with Azure Functions
🤖 AI-powered text extraction using Form Recognizer  
🧠 Intelligent document analysis with OpenAI GPT-3.5
📊 Comprehensive error handling and monitoring
📝 Complete English documentation and code comments
🔧 Ready for production deployment

Features:
✅ Blob trigger for automatic processing
✅ PDF text extraction with Form Recognizer
✅ AI analysis and summarization with OpenAI
✅ Detailed processing reports
✅ Real-time monitoring and logging
✅ Scalable serverless architecture

Built for CST8917 Lab Assignment by zhao0294
⚠️ Configure local.settings.json using the .example template"

# Set main branch
git branch -M main

# Add remote repository
echo "🔗 Adding remote repository..."
git remote add origin https://github.com/zhao0294/azure-pdf-processing-function.git

# Force push to override the problematic history
echo "🚀 Force pushing clean repository..."
git push -f origin main

echo ""
echo "🎉 SUCCESS! Clean repository uploaded!"
echo "🌐 Visit: https://github.com/zhao0294/azure-pdf-processing-function"
echo "📋 No sensitive data included in this push" 