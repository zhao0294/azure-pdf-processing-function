#!/bin/bash

# GitHub Upload Script for Azure PDF Processing Function
# Author: zhao0294
# Project: CST8917 Lab Assignment

echo "🚀 Starting GitHub upload process..."
echo "👤 GitHub Username: zhao0294"
echo "📁 Project: Azure PDF Processing Function"
echo ""

# Variables
GITHUB_USERNAME="zhao0294"
REPO_NAME="azure-pdf-processing-function"
GITHUB_URL="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"

# Check if we're in the right directory
if [ ! -f "function_app/__init__.py" ]; then
    echo "❌ Error: Not in the correct project directory!"
    echo "Please run this script from the testlab2 directory"
    exit 1
fi

echo "✅ Project directory confirmed"

# Step 1: Initialize Git repository (if not already done)
if [ ! -d ".git" ]; then
    echo "📦 Initializing Git repository..."
    git init
    echo "✅ Git repository initialized"
else
    echo "✅ Git repository already exists"
fi

# Step 2: Configure Git user (if not already configured)
echo "👤 Configuring Git user..."
git config user.name "zhao0294"
git config user.email "zhao0294@algonquinlive.com"  # Update with your actual email
echo "✅ Git user configured"

# Step 3: Check Git status
echo "📊 Checking Git status..."
git status

# Step 4: Add all files
echo "📁 Adding all project files..."
git add .
echo "✅ Files added to staging area"

# Step 5: Check what files will be committed
echo "📋 Files to be committed:"
git status --short

# Step 6: Create initial commit
echo "💾 Creating initial commit..."
git commit -m "Initial commit: Azure PDF Processing Function

- Serverless PDF processing with Azure Functions
- AI-powered text extraction using Form Recognizer  
- Intelligent document analysis with OpenAI GPT-3.5
- Comprehensive error handling and monitoring
- Complete English documentation and code comments
- Ready for production deployment

Features:
✅ Blob trigger for automatic processing
✅ PDF text extraction with Form Recognizer
✅ AI analysis and summarization with OpenAI
✅ Detailed processing reports
✅ Real-time monitoring and logging
✅ Scalable serverless architecture

Built for CST8917 Lab Assignment by zhao0294"

if [ $? -eq 0 ]; then
    echo "✅ Initial commit created successfully"
else
    echo "❌ Error creating commit"
    exit 1
fi

# Step 7: Set main branch
echo "🌿 Setting main branch..."
git branch -M main
echo "✅ Main branch set"

# Step 8: Add remote repository
echo "🔗 Adding remote repository..."
echo "📍 Repository URL: ${GITHUB_URL}"

# Remove existing remote if it exists
git remote remove origin 2>/dev/null

# Add new remote
git remote add origin ${GITHUB_URL}
echo "✅ Remote repository added"

# Step 9: Push to GitHub
echo "🚀 Pushing to GitHub..."
echo "⚠️  Note: You may need to authenticate with GitHub"
echo "💡 If prompted, use your GitHub personal access token as password"
echo ""

git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 SUCCESS! Project uploaded to GitHub!"
    echo "🌐 Repository URL: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
    echo "📚 View your project: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
    echo ""
    echo "📋 Next steps:"
    echo "1. Visit your GitHub repository to verify the upload"
    echo "2. Add repository description and topics on GitHub"
    echo "3. Consider enabling GitHub Pages for documentation"
    echo "4. Add collaborators if needed"
    echo ""
    echo "🎥 Ready for video demonstration!"
else
    echo ""
    echo "❌ Error: Failed to push to GitHub"
    echo "💡 Possible solutions:"
    echo "1. Make sure the repository exists on GitHub:"
    echo "   https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
    echo "2. Check your authentication (use personal access token)"
    echo "3. Verify your internet connection"
    echo "4. Run: git remote -v (to check remote URL)"
    echo ""
    echo "🔧 Manual commands to try:"
    echo "git remote set-url origin ${GITHUB_URL}"
    echo "git push -u origin main"
    exit 1
fi 