import azure.functions as func
import azure.durable_functions as df
import logging

app = df.DFApp()

# This file serves as the entry point for the activities
# Blob Trigger starts Durable Function
@app.blob_trigger(arg_name="inputBlob", path="input/{blobName}", connection="AzureWebJobsStorage")
@app.durable_client_input(client_name="client")
async def blob_trigger(inputBlob: func.InputStream, client: df.DurableOrchestrationClient):
    logging.info(f"Blob {inputBlob.name} uploaded, starting orchestration.")
    instance_id = await client.start_new("process_document", None, inputBlob.name.split("/")[-1])
    logging.info(f"Started orchestration with ID = {instance_id}")

def blob_trigger_function(req: func.BlobTrigger) -> str:
    logging.info(f"Python blob trigger function processed blob \n"
                f"Name: {req.name}\n"
                f"Blob Size: {req.length} bytes")
    return req.get_body(encoding='utf-8')