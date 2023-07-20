terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.60"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.60"
    }
  }
  required_version = ">= 1.4.0"
}

provider "google" {
}
