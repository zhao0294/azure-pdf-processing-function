import azure.functions as func
import azure.durable_functions as df
import logging
from azure.storage.blob import BlobServiceClient
import os
from datetime import datetime

app = df.DFApp()

@app.activity_trigger(input_name="data")
def write_doc(data: dict):
    logging.info(f"write_doc function called with data keys: {data.keys() if isinstance(data, dict) else 'not a dict'}")
    
    # Generate output filename
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_filename = f"summary_{timestamp}.txt"
    
    # Upload summary to output container
    # Implementation details would go here
    # This is a placeholder for the document writing logic
    
    return f"Document saved as {output_filename}"