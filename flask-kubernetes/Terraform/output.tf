
output "project_id" {
  value       = var.project_id
  description = "GCP Project ID"
}

output "zone" {
  value       = var.zone
  description = "Test Cluster Zone"
}

output "test_cluster_name" {
  value       = google_container_cluster.test_cluster.name
  description = "Test Cluster Name"
}

output "test_cluster_host" {
  value       = google_container_cluster.test_cluster.endpoint
  description = "Test Cluster IP"
}

output "prod_cluster_name" {
  value       = google_container_cluster.prod_cluster.name
  description = "Prod Cluster Name"
}

output "prod_cluster_host" {
  value       = google_container_cluster.prod_cluster.endpoint
  description = "Prod Cluster IP"
}
