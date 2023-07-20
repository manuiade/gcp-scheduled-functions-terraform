module "schedule_batch" {
  source = "../../"

  project_id = var.project_id

  service_account = {
    name         = "batch-job"
    display_name = "batch-job"
  }

  custom_role = {
    role_id = "batch_job"
    permissions = [
      "batch.jobs.create",
      "batch.states.report",
      "logging.logEntries.create",
      "logging.logEntries.route",
      "resourcemanager.projects.get"
    ]
  }

  source_code_bucket = {
    name     = var.bucket
    location = "EU"
    files = {
      "source-codes/batch-job.zip"          = "${path.module}/../../source-codes/batch-job/batch-job.zip"
      "source-codes/batch-code/Dockerfile"  = "${path.module}/../../source-codes/batch-job/batch-code/Dockerfile"
      "source-codes/batch-code/primegen.sh" = "${path.module}/../../source-codes/batch-job/batch-code/primegen.sh"
    }
  }

  functions = {
    "batch-job" : {
      region              = "europe-west1"
      runtime             = "python39"
      available_memory_mb = 128
      entry_point         = "create_batch_job"
      environment_variables = {
        PROJECT_ID            = var.project_id
        REGION                = "europe-west1"
        SCRIPT_TEXT           = file("${path.module}/../../source-codes/batch-job/batch-startup-script.sh")
        MACHINE_TYPE          = "e2-medium"
        SERVICE_ACCOUNT_EMAIL = "batch-job@${var.project_id}.iam.gserviceaccount.com"
        NETWORK               = "global/networks/default"
        SUBNETWORK            = "regions/europe-west1/subnetworks/default"
        BUCKET                = var.bucket
        FILE_PATH             = "source-codes/batch-code"
        PRIME_TARGET          = 1000000000
      }
      source_code = "source-codes/batch-job.zip"
      scheduler = {
        schedule    = "*/5 * * * *"
        time_zone   = "Europe/Rome"
        http_method = "GET"
      }
    }
  }
}
