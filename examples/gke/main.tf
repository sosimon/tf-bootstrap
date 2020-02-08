provider "google" {
  project     = var.project_id
  region      = "us-central1"
}

provider "google-beta" {
  project     = var.project_id
  region      = "us-central1"
}

resource "google_container_cluster" "primary" {
  provider = google-beta
  project  = var.project_id
  name     = "primary-cluster"
  location = "us-central1"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "12.97.18.0/24"
      display_name = "office"
    }
  }

  addons_config {
    istio_config {
      disabled = false
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "node-pool-1"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}