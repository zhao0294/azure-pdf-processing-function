import azure.functions as func
import azure.durable_functions as df
import logging

def orchestrator_function(context: df.DurableOrchestrationContext):
    logging.info("Starting PDF processing orchestration")
    
    # Configure retry policy
    retry_options = df.RetryOptions(first_retry_interval_in_milliseconds=5000, max_number_of_attempts=3)
    
    # Get blob info from trigger
    blob_info = context.get_input()
    
    # Activity 1: Analyze PDF
    result1 = yield context.call_activity_with_retry("analyze_pdf", blob_info, retry_options)
    
    # Activity 2: Summarize text
    result2 = yield context.call_activity_with_retry("summarize_text", result1, retry_options)
    
    # Activity 3: Save summary
    result3 = yield context.call_activity_with_retry("write_doc", result2, retry_options)
    
    return result3

main = df.Orchestrator.create(orchestrator_function)