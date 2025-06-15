import azure.functions as func
import logging
import os
from azure.ai.formrecognizer import DocumentAnalysisClient
from azure.core.credentials import AzureKeyCredential
from azure.storage.blob import BlobServiceClient

def main(blobTrigger: func.InputStream):
    logging.info(f'✅ Python blob trigger function processed blob \n'
                f'Name: {blobTrigger.name}\n'
                f'Blob Size: {blobTrigger.length} bytes')
    
    try:
        # Get configuration
        cognitive_services_endpoint = os.environ.get("COGNITIVE_SERVICES_ENDPOINT")
        cognitive_services_key = os.environ.get("COGNITIVE_SERVICES_KEY")
        azure_openai_endpoint = os.environ.get("AZURE_OPENAI_ENDPOINT")
        azure_openai_key = os.environ.get("AZURE_OPENAI_KEY")
        chat_model_deployment = os.environ.get("CHAT_MODEL_DEPLOYMENT_NAME")
        
        # Read PDF content
        pdf_content = blobTrigger.read()
        logging.info(f"✅ Successfully read PDF content: {len(pdf_content)} bytes")
        
        # Extract text using Azure Form Recognizer
        extracted_text = ""
        if cognitive_services_endpoint and cognitive_services_key and cognitive_services_key != "YOUR_FORM_RECOGNIZER_API_KEY_HERE":
            try:
                logging.info("🔍 Starting PDF text extraction with Form Recognizer...")
                credential = AzureKeyCredential(cognitive_services_key)
                document_analysis_client = DocumentAnalysisClient(cognitive_services_endpoint, credential)
                
                # Analyze PDF document
                poller = document_analysis_client.begin_analyze_document("prebuilt-document", pdf_content)
                result = poller.result()
                
                # Extract text content
                for page in result.pages:
                    for line in page.lines:
                        extracted_text += line.content + "\n"
                
                if not extracted_text.strip():
                    extracted_text = "No text content could be extracted from PDF"
                else:
                    logging.info(f"✅ Successfully extracted {len(extracted_text)} characters from PDF")
                    
            except Exception as e:
                logging.error(f"❌ Error using Form Recognizer: {str(e)}")
                extracted_text = f"Text extraction error: {str(e)}"
        else:
            logging.warning("⚠️ Form Recognizer not configured properly")
            extracted_text = "Form Recognizer not configured - unable to extract PDF text"
        
        # Process extracted text using OpenAI
        processed_content = ""
        if azure_openai_endpoint and azure_openai_key and extracted_text.strip():
            try:
                logging.info("🤖 Starting AI processing with OpenAI...")
                from openai import AzureOpenAI
                
                client = AzureOpenAI(
                    azure_endpoint=azure_openai_endpoint,
                    api_key=azure_openai_key,
                    api_version="2023-05-15"
                )
                
                # Prepare text for AI (limit length to avoid token limits)
                text_for_ai = extracted_text[:2000] if len(extracted_text) > 2000 else extracted_text
                
                response = client.chat.completions.create(
                    model=chat_model_deployment,
                    messages=[
                        {"role": "system", "content": "You are a professional document analysis assistant. Please summarize document content and extract key information."},
                        {"role": "user", "content": f"Please analyze the following PDF document content and provide a concise summary:\n\n{text_for_ai}"}
                    ],
                    max_tokens=500,
                    temperature=0.7
                )
                
                processed_content = response.choices[0].message.content
                logging.info("✅ Successfully processed text with OpenAI")
                
            except Exception as e:
                logging.error(f"❌ Error calling OpenAI: {str(e)}")
                processed_content = f"AI processing error: {str(e)}"
        else:
            if not azure_openai_endpoint or not azure_openai_key:
                processed_content = "OpenAI not configured - skipping AI analysis"
            elif not extracted_text.strip():
                processed_content = "No available text for AI analysis"
            else:
                processed_content = "AI processing skipped"
        
        # Save results to output container
        try:
            blob_service_client = BlobServiceClient.from_connection_string(
                os.environ.get("AzureWebJobsStorage")
            )
            
            # Get filename (remove path and extension)
            file_name = blobTrigger.name.split('/')[-1].replace('.pdf', '')
            output_blob_name = f"{file_name}_processed.txt"
            
            # Upload to output container
            blob_client = blob_service_client.get_blob_client(
                container="output", 
                blob=output_blob_name
            )
            
            # Generate detailed processing results
            result_content = f"=== PDF Document Processing Report ===\n"
            result_content += f"Processing Time: {logging.Formatter().formatTime(logging.LogRecord('', 0, '', 0, '', (), None))}\n"
            result_content += f"Original Filename: {blobTrigger.name}\n"
            result_content += f"File Size: {blobTrigger.length} bytes\n"
            result_content += f"PDF Content Size: {len(pdf_content)} bytes\n\n"
            
            result_content += f"=== Configuration Status ===\n"
            result_content += f"Form Recognizer: {'✅ Configured' if cognitive_services_endpoint and cognitive_services_key else '❌ Not configured'}\n"
            result_content += f"OpenAI: {'✅ Configured' if azure_openai_endpoint and azure_openai_key else '❌ Not configured'}\n"
            result_content += f"Model Deployment: {chat_model_deployment or 'Not set'}\n\n"
            
            result_content += f"=== Extracted Text Content ===\n"
            result_content += extracted_text[:1000]  # Limit length
            if len(extracted_text) > 1000:
                result_content += f"\n...(Text too long, truncated. Total length: {len(extracted_text)} characters)\n"
            result_content += "\n\n"
            
            result_content += f"=== AI Analysis Results ===\n"
            result_content += processed_content + "\n\n"
            
            result_content += f"=== Processing Status ===\n"
            result_content += f"✅ PDF File Reception: Success\n"
            result_content += f"✅ File Reading: Success\n"
            result_content += f"{'✅' if extracted_text and 'Form Recognizer not configured' not in extracted_text else '❌'} Text Extraction: {'Success' if extracted_text and 'Form Recognizer not configured' not in extracted_text else 'Failed'}\n"
            result_content += f"{'✅' if processed_content and 'OpenAI not configured' not in processed_content and 'error' not in processed_content.lower() else '❌'} AI Analysis: {'Success' if processed_content and 'OpenAI not configured' not in processed_content and 'error' not in processed_content.lower() else 'Failed'}\n"
            result_content += f"✅ Result Saving: Success\n"
            
            blob_client.upload_blob(result_content, overwrite=True)
            
            logging.info(f"✅ Successfully processed and saved complete result to output/{output_blob_name}")
            
        except Exception as e:
            logging.error(f"❌ Error saving to output container: {str(e)}")
            raise
    
    except Exception as e:
        logging.error(f"❌ Error processing blob: {str(e)}")
        raise
