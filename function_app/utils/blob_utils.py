from azure.storage.blob import BlobServiceClient
import os

def get_blob_service_client():
    connection_string = os.environ["AzureWebJobsStorage"]
    return BlobServiceClient.from_connection_string(connection_string)

def download_blob(blob_name: str, container_name: str) -> bytes:
    blob_service_client = get_blob_service_client()
    blob_client = blob_service_client.get_blob_client(
        container=container_name, blob=blob_name
    )
    return blob_client.download_blob().readall()

def upload_blob(blob_name: str, data: str, container_name: str):
    blob_service_client = get_blob_service_client()
    blob_client = blob_service_client.get_blob_client(
        container=container_name, blob=blob_name
    )
    blob_client.upload_blob(data, overwrite=True)