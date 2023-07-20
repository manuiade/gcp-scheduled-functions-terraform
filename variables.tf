//-----------------------------------------------------------------------------
// variables.tf - contains the definition of variables used by Terraform
//-----------------------------------------------------------------------------


variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "service_account" {
  description = "Info on service account used for scheduled routine"
  type = object({
    name         = string
    display_name = optional(string)
    description  = optional(string)
  })
}

variable "custom_role" {
  description = "Custom roles assigned to the service account performing the operation"
  type = object({
    role_id     = string
    title       = optional(string)
    permissions = list(string)
  })
  default = null
}

variable "source_code_bucket" {
  description = "Info on bucket for hosting source code of cloud functions"
  type = object({
    name     = string
    location = string
    files    = map(string)
  })
}

variable "functions" {
  description = "Cloud Function v1 configuration"
  type = map(object({
    region                = string
    runtime               = string
    available_memory_mb   = optional(number, 128)
    entry_point           = string
    environment_variables = optional(map(string), {})
    source_code           = string
    secrets               = optional(map(string), {})
    scheduler = object({
      schedule    = string
      time_zone   = string
      http_method = optional(string, "GET")
    })
  }))
}
