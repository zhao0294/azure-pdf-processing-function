import os
from azure.ai.formrecognizer import DocumentAnalysisClient
from azure.core.credentials import AzureKeyCredential
from openai import AzureOpenAI

# Form Recognizer configuration
endpoint = os.environ.get("COGNITIVE_SERVICES_ENDPOINT")
key = os.environ.get("COGNITIVE_SERVICES_KEY")  # Configure in local.settings.json

def extract_text_with_form_recognizer(pdf_content: bytes) -> str:
    """Extract text from PDF using Azure Form Recognizer"""
    if not endpoint or not key:
        raise ValueError("Form Recognizer endpoint and key must be configured")
    
    credential = AzureKeyCredential(key)
    document_analysis_client = DocumentAnalysisClient(endpoint, credential)
    
    poller = document_analysis_client.begin_analyze_document("prebuilt-document", pdf_content)
    result = poller.result()
    
    extracted_text = ""
    for page in result.pages:
        for line in page.lines:
            extracted_text += line.content + "\n"
    
    return extracted_text

def summarize_with_openai(text: str) -> str:
    """Summarize text using Azure OpenAI"""
    azure_openai_endpoint = os.environ.get("AZURE_OPENAI_ENDPOINT")
    azure_openai_key = os.environ.get("AZURE_OPENAI_KEY")
    deployment_name = os.environ.get("CHAT_MODEL_DEPLOYMENT_NAME", "gpt-35-turbo")
    
    if not azure_openai_endpoint or not azure_openai_key:
        raise ValueError("Azure OpenAI endpoint and key must be configured")
    
    client = AzureOpenAI(
        azure_endpoint=azure_openai_endpoint,
        api_key=azure_openai_key,
        api_version="2023-05-15"
    )
    
    response = client.chat.completions.create(
        model=deployment_name,
        messages=[
            {"role": "system", "content": "You are a helpful assistant that summarizes documents."},
            {"role": "user", "content": f"Please summarize the following text:\n\n{text}"}
        ],
        max_tokens=300,
        temperature=0.7
    )
    
    return response.choices[0].message.content