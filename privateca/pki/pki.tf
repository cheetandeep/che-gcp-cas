# Subordinate CA
module "sub_root" {
  source = "../module"
  project_id = local.project_id
  region = local.region
  ca_name = "che_sub"
  tier = "DEVOPS"
  type = "SUBORDINATE"
  country_code = "CA"
  organization = "che-org"
  organizational_unit = "dev"
  lifetime = "31536000s"
  key_algorithm = "EC_P256_SHA256"

  create_k8s_configmap = true
  k8s_configmap_namespaces = "hsm"

num_ca = 1
create_k8s_issuer = true
}

# Root CA
module "root_ca" {
  source = "../module"
  project_id = local.project_id
  region = local.region
  ca_name = "che_root"
  tier = "DEVOPS"
  type = "SELF_SIGNED"
  country_code = "CA"
  organization = "che-org"
  organizational_unit = "dev"
  lifetime = "31536000s"
  key_algorithm = "EC_P256_SHA256"

  create_k8s_configmap = true
  k8s_configmap_namespaces = "hsm"

num_ca = 1
create_k8s_issuer = false
}