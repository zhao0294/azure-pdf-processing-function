import azure.functions as func
import azure.durable_functions as df
import logging
from openai import AzureOpenAI
import os

app = df.DFApp()

# Use Azure OpenAI to summarize text
@app.activity_trigger(input_name="extractedText")
def summarize_text(extractedText: str):
    logging.info(f"summarize_text function called with text length: {len(extractedText)}")
    
    # Implementation details would go here
    # This is a placeholder for the text summarization logic
    
    return f"Summary of text: {extractedText[:100]}..."