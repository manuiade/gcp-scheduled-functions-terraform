//-----------------------------------------------------------------------------
// schedule.tf - setup bucket with source code for function and scheduler job
//-----------------------------------------------------------------------------

// Dedicated service account
resource "google_service_account" "schedule_sa" {
  account_id = var.service_account.name
  display_name = var.service_account.display_name
  description = var.service_account.description
  project      = var.project_id
}

// Custom role with minimum permission required
resource "google_project_iam_custom_role" "schedule_custom_role" {
  role_id     = var.custom_role.role_id
  title       = var.custom_role.title != null ? var.custom_role.title : var.custom_role.role_id
  permissions = var.custom_role.permissions
  project     = var.project_id
}

// IAM custom role assigned to service account
resource "google_project_iam_member" "schedule_custom_role_sa_iam" {
  project = var.project_id
  role    = google_project_iam_custom_role.schedule_custom_role.id
  member  = format("serviceAccount:%s", google_service_account.schedule_sa.email)
}

// Create the bucket hosting the Cloud Function source code
resource "google_storage_bucket" "source_code_bucket" {
  name          = var.source_code_bucket.name
  location      = var.source_code_bucket.location
  force_destroy = true
  project       = var.project_id
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

// Upload source code to GCS bucket
resource "google_storage_bucket_object" "source_code_bucket" {
  for_each = var.functions
  bucket = google_storage_bucket.source_code_bucket.name
  name   = each.value.zip_name
  source = each.value.zip_source
}

// Creates/updates the cloud function
resource "google_cloudfunctions_function" "schedule_function" {
  for_each = var.functions
  name                  = each.key
  project               = var.project_id
  region                = each.value.region
  runtime               = each.value.runtime
  service_account_email = google_service_account.schedule_sa.email
  source_archive_bucket = google_storage_bucket.source_code_bucket.name
  source_archive_object = google_storage_bucket_object.source_code_bucket["${each.key}"].name
  timeout               = 540
  trigger_http          = true
  available_memory_mb   = try(each.value.available_memory_mb, 128)
  entry_point           = each.value.entry_point
  environment_variables = each.value.environment_variables
  ingress_settings = "ALLOW_ALL"
  max_instances    = 1

  lifecycle {
    replace_triggered_by = [
      google_storage_bucket_object.source_code_bucket[each.key].md5hash
    ]
  }

}

// Grant SA invoke permission to cloud function
resource "google_cloudfunctions_function_iam_member" "schedule_function_invoke" {
  for_each = var.functions
  project = var.project_id
  region = each.value.region
  cloud_function = google_cloudfunctions_function.schedule_function["${each.key}"].name
  role = "roles/cloudfunctions.invoker"
  member = format("serviceAccount:%s", google_service_account.schedule_sa.email)
}

// Creates/update the Cloud Scheduler Job which periodically calls the Function for the certificate rotation
resource "google_cloud_scheduler_job" "schedule_job" {
  for_each = var.functions
  name      = each.key
  schedule  = each.value.scheduler.schedule
  time_zone = each.value.scheduler.time_zone
  project   = var.project_id
  region    = each.value.region
  http_target {
    http_method = each.value.scheduler.http_method
    uri         = google_cloudfunctions_function.schedule_function["${each.key}"].https_trigger_url
    oidc_token {
      service_account_email = google_service_account.schedule_sa.email
    }
  }
}