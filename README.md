# Azure PDF Processing Function

## 📋 Project Overview

This project demonstrates a **serverless PDF processing solution** using Azure Functions, Form Recognizer, and OpenAI. The function automatically processes PDF documents uploaded to Azure Storage, extracts text content, performs AI analysis, and saves detailed processing reports.

## 🏗️ Architecture

```
PDF Upload → Azure Storage (input) → Azure Function → Form Recognizer → OpenAI → Processing Report → Azure Storage (output)
```

### Key Components:
- **Azure Functions** - Serverless compute platform
- **Azure Form Recognizer** - AI-powered document text extraction
- **Azure OpenAI** - GPT-3.5 for intelligent document analysis
- **Azure Blob Storage** - File storage for input/output
- **Python 3.10** - Runtime environment

## ✨ Features

### 🔄 Automated Processing Pipeline
- **Blob Trigger**: Automatically processes PDF files when uploaded
- **Text Extraction**: Uses Azure Form Recognizer for accurate OCR
- **AI Analysis**: Leverages OpenAI GPT-3.5 for content summarization
- **Detailed Reporting**: Generates comprehensive processing reports

### 📊 Processing Report Includes:
- File metadata (name, size, processing time)
- Configuration status verification
- Extracted text content (with length limits)
- AI-generated analysis and summary
- Step-by-step processing status

### 🛡️ Error Handling & Monitoring
- Comprehensive logging at each processing step
- Graceful fallback for missing configurations
- Processing status tracking
- Real-time monitoring through Azure Portal

## 🚀 Quick Start

### Prerequisites
- Azure subscription
- Azure CLI installed
- Azure Functions Core Tools
- Python 3.10+

### 1. Clone and Setup
```bash
git clone <repository-url>
cd testlab2
python3.10 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 2. Deploy to Azure
```bash
# Using Azure Developer CLI (Recommended)
azd up

# Or using Azure Functions Core Tools
func azure functionapp publish <your-function-app-name> --python
```

### 3. Configure Environment Variables
Set these in your Function App settings:
```
COGNITIVE_SERVICES_ENDPOINT=https://your-form-recognizer.cognitiveservices.azure.com/
COGNITIVE_SERVICES_KEY=your-form-recognizer-key
AZURE_OPENAI_ENDPOINT=https://your-openai.cognitiveservices.azure.com/
AZURE_OPENAI_KEY=your-openai-key
CHAT_MODEL_DEPLOYMENT_NAME=gpt-35-turbo
```

## 📁 Project Structure

```
testlab2/
├── function_app/
│   ├── __init__.py          # Main function logic
│   ├── function.json        # Function binding configuration
│   └── utils/
│       └── ai_utils.py      # AI processing utilities
├── requirements.txt         # Python dependencies
├── host.json               # Function app configuration
├── local.settings.json     # Local development settings
├── azure.yaml             # Azure deployment configuration
└── deploy.sh              # Deployment script
```

## 🎯 Demo Walkthrough

### Step 1: Upload PDF File
1. Navigate to Azure Storage Account
2. Access the `input` container
3. Upload any PDF file

### Step 2: Automatic Processing
The function automatically:
1. Detects the uploaded file
2. Reads PDF content
3. Extracts text using Form Recognizer
4. Analyzes content with OpenAI
5. Generates processing report

### Step 3: View Results
Check the `output` container for:
- Detailed processing report
- Extracted text content
- AI analysis summary
- Processing statistics

## 📊 Sample Output

```
=== PDF Document Processing Report ===
Processing Time: 2025-06-15 15:22:54,929
Original Filename: input/test.pdf
File Size: 10436 bytes
PDF Content Size: 10436 bytes

=== Configuration Status ===
Form Recognizer: ✅ Configured
OpenAI: ✅ Configured
Model Deployment: gpt-35-turbo

=== Extracted Text Content ===
Just test for CST8917lab2!
thanks

=== AI Analysis Results ===
The content of the PDF document is very brief and consists of a simple message: 
"Just test for CST8917lab2! thanks." It seems to be related to a testing activity 
for a lab assignment or course with the code CST8917.

=== Processing Status ===
✅ PDF File Reception: Success
✅ File Reading: Success
✅ Text Extraction: Success
✅ AI Analysis: Success
✅ Result Saving: Success
```

## 🔧 Technical Implementation

### Function Trigger Configuration
```json
{
  "bindings": [
    {
      "name": "blobTrigger",
      "type": "blobTrigger",
      "direction": "in",
      "path": "input/{blobName}",
      "connection": "AzureWebJobsStorage"
    }
  ]
}
```

### Key Dependencies
```txt
azure-functions==1.23.0
azure-storage-blob==12.25.1
azure-ai-formrecognizer==3.3.3
azure-core==1.34.0
openai==1.86.0
```

## 📈 Performance & Scalability

- **Processing Time**: ~10-30 seconds per PDF (depending on size)
- **Concurrent Processing**: Supports multiple simultaneous uploads
- **File Size Limit**: Up to 50MB per PDF
- **Cost Model**: Pay-per-execution (serverless)

## 🔍 Monitoring & Debugging

### Real-time Logs
```bash
# View function logs
az functionapp logs tail --name <function-app-name> --resource-group <resource-group>
```

### Application Insights Integration
- Processing duration tracking
- Error rate monitoring
- Custom telemetry events

## 🛠️ Troubleshooting

### Common Issues:
1. **Configuration Missing**: Verify all environment variables
2. **Permission Errors**: Check storage account access keys
3. **Processing Failures**: Review function logs in Azure Portal

### Debug Commands:
```bash
# Check function status
az functionapp show --name <function-app> --resource-group <rg>

# Restart function app
az functionapp restart --name <function-app> --resource-group <rg>
```

## 🎥 Video Demonstration Points

### Minute 1-2: Introduction & Architecture
- Project overview and business value
- Architecture diagram walkthrough
- Key Azure services explanation

### Minute 3-4: Code Structure
- Function implementation highlights
- Configuration and deployment setup
- Dependencies and requirements

### Minute 5-7: Live Demo
- Upload PDF to Azure Storage
- Show real-time processing
- Review generated output report

### Minute 8-9: Advanced Features
- Error handling and monitoring
- Scalability considerations
- Cost optimization

### Minute 10: Summary & Next Steps
- Key takeaways
- Potential enhancements
- Production considerations

## 🚀 Future Enhancements

- **Multi-format Support**: Word, Excel, PowerPoint processing
- **Batch Processing**: Handle multiple files simultaneously
- **Custom AI Models**: Fine-tuned models for specific document types
- **Integration APIs**: REST endpoints for external applications
- **Advanced Analytics**: Document classification and entity extraction

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

---

**Built with ❤️ for CST8917 Lab Assignment**

# 检查这些文件是否被.gitignore正确排除
ls -la local.settings.json  # 包含API密钥
ls -la .env                 # 环境变量
ls -la venv/                # 虚拟环境
