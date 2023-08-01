provider "google" {
  credentials = file("~/Documents/Kubernetes_admin_named-signal-392608-475533c7a170.json")
  project     = var.project_id
}

variable "project_id" {
  description = "GCP Project ID"
}

variable "zone" {
  description = "Cluster Zone"
}
