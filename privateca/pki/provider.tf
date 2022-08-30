terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
            version = ">=3.83.0"
        }
        kubernetes {
            source = "hashicorp/kubernetes"
            version = ">=2.4"
        }
    }
}

provider "google" {}

data "google_service_account_access_token" "default" {
  provider =  google
  target_service_account = local.target_service_account
  scopes = ["userinfo-email","cloud-platform"]
  lifetime = "3600s"
}

data "google_container_cluster" "gke" {
  name = local.gke_name
location = local.region
project = local.gke_project_id
}

provider "kubernetes" {
 host                   = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
  experiments {
    manifest_resource = true
  }
}
