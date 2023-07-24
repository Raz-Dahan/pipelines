provider "google" {
  project = "named-signal-392608"
  region  = "us-east1"
}

resource "google_container_cluster" "test_cluster" {
  name               = "test-cluster"
  location           = "us-east1-b"
  initial_node_count = 3

  master_auth {
    username = ""
    password = ""
  }

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 32

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    service_account = "default"

    tags = ["default"]

    taint {
      key    = "node-type"
      value  = "test"
      effect = "NO_SCHEDULE"
    }

    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

    vertical_pod_autoscaling {
      enabled = true
    }

    shielded_instance_config {
      enable_secure_boot          = false
      enable_integrity_monitoring = true
    }
  }

  logging_service = "SYSTEM,WORKLOAD"
  monitoring_service = "SYSTEM"

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "172.16.0.0/14"
  }

  remove_default_node_pool = true

  network = "default"
  subnetwork = "default"
  location_policy = "ANY"

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }

    http_load_balancing {
      disabled = false
    }

    gce_persistent_disk_csi_driver {
      disabled = false
    }
  }

  autoupgrade = true
  autorepair  = true

  max_surge_upgrade    = 1
  max_unavailable_upgrade = 0

  vertical_pod_autoscaling {
    enabled = true
  }
}

resource "google_container_cluster" "prod_cluster" {
  name               = "prod-cluster"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = ""
  }

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 32

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    service_account = "default"

    tags = ["default"]

    taint {
      key    = "node-type"
      value  = "prod"
      effect = "NO_SCHEDULE"
    }

    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

    vertical_pod_autoscaling {
      enabled = true
    }

    shielded_instance_config {
      enable_secure_boot          = false
      enable_integrity_monitoring = true
    }
  }

  logging_service = "SYSTEM,WORKLOAD"
  monitoring_service = "SYSTEM"

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "172.17.0.0/14"
  }

  remove_default_node_pool = true

  network = "default"
  subnetwork = "default"
  location_policy = "ANY"

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }

    http_load_balancing {
      disabled = false
    }

    gce_persistent_disk_csi_driver {
      disabled = false
    }
  }

  autoupgrade = true
  autorepair  = true

  max_surge_upgrade    = 1
  max_unavailable_upgrade = 0

  vertical_pod_autoscaling {
    enabled = true
  }
}
