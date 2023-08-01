
resource "google_container_cluster" "prod_cluster" {
  name               = "prod-cluster"
  location           = var.zone
  initial_node_count = 1
}

resource "google_container_node_pool" "prod_node_pool" {
  name       = "prod-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.prod_cluster.name
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 24
    disk_type    = "pd-standard"
  }
}
