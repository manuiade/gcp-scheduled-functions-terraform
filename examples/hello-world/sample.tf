module "schedule_backup" {
  source = "../../"

  project_id = var.project_id

  service_account = {
    name         = "hello-world-schedule"
    display_name = "hello-world-schedule"
  }

  custom_role = {
    role_id = "test_role3"
    permissions = [
      "compute.instances.list",
    ]
  }

  source_code_bucket = {
    name     = var.bucket
    location = "EU"
    files = {
      "source-codes/code-1.zip" = "${path.module}/../../source-codes/code-1/code-1.zip",
      "source-codes/code-2.zip" = "${path.module}/../../source-codes/code-2/code-2.zip"
    }
  }

  functions = {
    "hello-world-schedule-1" : {
      region              = "europe-west1"
      runtime             = "python39"
      available_memory_mb = 128
      entry_point         = "hello_world_schedule_1"
      environment_variables = {
        KEY = "value-1"
      }
      source_code = "source-codes/code-1.zip"
      scheduler = {
        schedule    = "*/5 * * * *"
        time_zone   = "Europe/Rome"
        http_method = "GET"
      }
    },
    "hello-world-schedule-2" : {
      region              = "europe-west1"
      runtime             = "python39"
      available_memory_mb = 128
      entry_point         = "hello_world_schedule_2"
      environment_variables = {
        KEY = "value-2"
      }
      secrets = {
        "_SECRET_1" = "secret-1"
        "_SECRET_2" = "secret-2"
      }
      source_code = "source-codes/code-2.zip"
      scheduler = {
        schedule    = "*/5 * * * *"
        time_zone   = "Europe/Rome"
        http_method = "GET"
      }
    },
  }
}
