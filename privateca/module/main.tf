provider google{}
provider tls{}

resource "tls_private_key" "example" {
  algorithm   = "RSA"
}

locals{
    # Must be a unique resource id
    ca_id = [for n in range(var.num_ca): format("%s-%s", var.ca_name, random_id.random_ca_id_suffix[n].hex)]
}

resource "google_privateca_ca_pool" "pool" {
  name = var.ca_name
  project = var.project_id
  location = var.region 
  tier = var.tier
  publishing_options {
    publish_ca_cert = false
    publish_crl = false
  }
}

resource "google_privateca_certificate_authority" "ca" {
  count = var.num_ca
  depends_on =[
      google_privateca_ca_pool.pool
  ]
pool = google_privateca_ca_pool.pool.name
project = var.project_id
location = var.region
type = var.type
  config {
    subject_config {
      subject {
        country_code = "us"
        organization = "google"
        organizational_unit = "enterprise"
        common_name = "my-certificate-authority"
      }
    }
}
      key_usage {
        base_key_usage {
          # cert_sign and crl_sign *MUST* be true for certificate authorities
          digital_signature = lookup(var.digital_signature, var.type)
          key_encipherment =  lookup(var.key_encipherment, var.type)
          cert_sign = true
          crl_sign = true
        }
        extended_key_usage{}
      }
      lifetime = var.lifetime
      key_spec{
          algorithm = var.key_algorithm
      }
}

resource "kubernetes_manifest" "googlecasclusterissuer" {
  # only for intermediates
  count = var.create_k8s_issuer ? 1:0
  depends_on=[
random_id.random_ca_id_suffix,
google_privateca_certificate_authority.ca
  ]
manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind" =  "GoogleCASIssuer"
    "metadata" = {
        "labels" = {
         "app" = "google-cas-issuer"
        }
        "name" = lower(var.ca_name)
    }
    "spec" = {
   "project" =  var.project_id
  "location" =  var.region
  "caPoolId" =  var.ca_name       
    }
}
}

resource "kubernetes_manifest" "certificate" {
  count = var.create_k8s_issuer ? 1:0
  manifest = {
      "apiVersion" =  "cert-manager.io/v1"
      "kind" = "Certificate"
      "metadata" =  {
        "labels" = {
          "app" = lower("$(var.ca_name)-monitor")  
        }
      "name" = lower("$(var.ca_name)-monitor") 
      "namespace" = var.monitor_cert_namespace  
      }
"spec" = {
  # Common Name
   "commonName" = lower("$(var.ca_name)-monitor") 
  # DNS SAN
  "dnsNames" =  [lower(var.ca_name)]
# Renew as per the variable value hours before the certificate expiration
  "renewBefore" =  var.monitor_cert_renew_before
 # Duration of the certificate
  "duration" = var.monitor_cert_duration
  "issuerRef" = {
    "group" =  "cas-issuer.jetstack.io"
    "kind" =  "GoogleCASClusterIssuer" # or GoogleCASIssuer
    "name" =  lower(trimsuffix(var.ca_name,"-monitor"))     
  }
"privateKey" = {
    "algorithm"  = lookup(var.monitor_cert_private_key_algorithm, var.key_algorithm)
    "size" = lookup(var.monitor_cert_private_key_size, var.key_algorithm)
}
  # The secret name to store the signed certificate
  "secretName" =  lower("$(var.ca_name)-monitor-tls")
  "subject" = {
      "organizations" = [
          "che-org"
      ]
  }
  "usages" = var.usages
    }
  }
}
