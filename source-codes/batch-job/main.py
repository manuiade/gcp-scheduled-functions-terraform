from google.cloud import batch_v1
import os

# Parse and adjust variables
PROJECT_ID = os.environ.get('PROJECT_ID')
REGION = os.environ.get('REGION')
SCRIPT_TEXT=os.environ.get('SCRIPT_TEXT')
MACHINE_TYPE=os.environ.get('MACHINE_TYPE')
SERVICE_ACCOUNT_EMAIL=os.environ.get('SERVICE_ACCOUNT_EMAIL')
NETWORK=os.environ.get('NETWORK')
SUBNETWORK=os.environ.get('SUBNETWORK')
BUCKET=os.environ.get('BUCKET')
FILE_PATH=os.environ.get('FILE_PATH')
PRIME_TARGET=os.environ.get('PRIME_TARGET')


def create_batch_job(request):
    client = batch_v1.BatchServiceClient()
    allocation_policy = batch_v1.AllocationPolicy(
        instances = [
            batch_v1.AllocationPolicy.InstancePolicyOrTemplate(
                policy = batch_v1.AllocationPolicy.InstancePolicy(
                    machine_type = MACHINE_TYPE
                )
            )
        ],
        service_account = batch_v1.ServiceAccount(
            email = SERVICE_ACCOUNT_EMAIL,
            scopes = ["https://www.googleapis.com/auth/cloud-platform"]
        ),
        network = batch_v1.AllocationPolicy.NetworkPolicy(
            network_interfaces = [
                batch_v1.AllocationPolicy.NetworkInterface(
                    network = NETWORK,
                    subnetwork = SUBNETWORK,
                    no_external_ip_address = False
                )
            ]
        )
    )
    task_group = batch_v1.TaskGroup(
        task_spec = batch_v1.TaskSpec(
            runnables = [
                batch_v1.Runnable(
                    script = batch_v1.Runnable.Script(
                        text = SCRIPT_TEXT
                    ),
                    environment = batch_v1.Environment(
                        variables = {
                         "BUCKET" : BUCKET,
                         "FILE_PATH" : FILE_PATH,
                         "PRIME_TARGET" : PRIME_TARGET
                        }
                    )
                )
            ]
        )
    )

    
    logs_policy = batch_v1.LogsPolicy(
        destination = batch_v1.LogsPolicy.Destination.CLOUD_LOGGING
    )

    job = batch_v1.Job(task_groups = [task_group], allocation_policy = allocation_policy, logs_policy = logs_policy)
    create_job_request = batch_v1.CreateJobRequest(parent="projects/{PROJECT_ID}/locations/{REGION}".format(PROJECT_ID=PROJECT_ID, REGION=REGION), job = job)
    print("Creating job..")
    client.create_job(create_job_request)
    return "Job created successfully"