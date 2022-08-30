variable "num_ca" {
    type = number
    description = "The number of CAs to add to the pool"
    default = 1
}

variable "project_id" {
    type = string
    description = "Project Id where the CA will be created"
}

variable "ca_name" {
  type = string
  description = "CA name"
}

variable "region" {
  type = string
  description = "Location/region of the CA"
}

variable "tier" {
  type = string
  description = "Tier of the CA: DEVOPS or ENTERPRISE"
  validation{
      condition = var.tier == "ENTERPRISE" || var.tier == "DEVOPS"
      error_message = "The tier value be either ENTERPRISE or DEVOPS"
  }
}

variable "type" {
  type = string
  description = "Type of CA either SUBORDINATE or SELF_SIGNED(Root)"
  validation{
      condition = var.type == "SUBORDINATE" || var.type == "SELF_SIGNED"
      error_message = "The type should be either SUBORDINATE or SELF_SIGNED(Root)"
  }
}

variable "lifetime" {
  type = string
  description = "The desired lifetime of the CA certificate. Used to create the \"notBeforeTime\" and \"notAfterTime\" fields inside an X.509 certificate. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: \"3.5s\""
  validation {
      condition = can(regex("^[0-9]+(\\.[0-9]{1,9})?s$",var.lifetime))
      error_message = "The value must be in s with up to nine fractional digits, terminated by 's' "
  }
}

variable "key_algorithm" {
  type = string
  description = "The algorithm to use for creating a managed Cloud KMS key for a for a simplified experience. All managed keys will be have their ProtectionLevel as HSM. Possible values are SIGN_HASH_ALGORITHM_UNSPECIFIED, RSA_PSS_2048_SHA256, RSA_PSS_3072_SHA256, RSA_PSS_4096_SHA256, RSA_PKCS1_2048_SHA256, RSA_PKCS1_3072_SHA256, RSA_PKCS1_4096_SHA256, EC_P256_SHA256, and EC_P384_SHA384."
  validation{
        condition = contains([
      "SIGN_HASH_ALGORITHM_UNSPECIFIED",
      "RSA_PSS_2048_SHA256",
      "RSA_PSS_3072_SHA256",
    "RSA_PSS_4096_SHA256",
    "RSA_PKCS1_2048_SHA256",
    "RSA_PKCS1_3072_SHA256",
    "RSA_PKCS1_4096_SHA256",
    "EC_P256_SHA256",
    "EC_P384_SHA384"], var.key_algorithm)
    error_message = "The algorithm value must support from the mentioned list"
  }
}

variable "create_k8s_configmap" {
  type =  bool
  description = "If true create a k8s configmap resource for the CA"
}

variable "k8s_configmap_namespaces" {
  type = list(string)
  description = "A list of namespaces to create the k8s configmap in"
  default = [ "hsm" ]
}

variable "create_k8s_issuer" {
  type = bool
  description = "Creates a k8s GoogelCASClusterIssuer resource is set to true"
}

variable "monitor_cert_namespace" {
  type = string
  description = "The namespace where the certificate is created"
  default = "nu-system"
}

variable "monitor_cert_duration" {
  type = string
  description = "The duration that the cert will be valid for. Format:24h10m67s"
  default = "300h0m0s"
}

variable "monitor_cert_private_key_algorithm" {
  type = map(any)
  description = "The algorithm used for creating a managed Cloud KMS key for a simplified experience. All managed keys will have their Protection level as HSM. ossible values are SIGN_HASH_ALGORITHM_UNSPECIFIED, RSA_PSS_2048_SHA256, RSA_PSS_3072_SHA256, RSA_PSS_4096_SHA256, RSA_PKCS1_2048_SHA256, RSA_PKCS1_3072_SHA256, RSA_PKCS1_4096_SHA256, EC_P256_SHA256, and EC_P384_SHA384"
  default = {
    "RSA_PSS_2048_SHA256" = "RSA"
    "RSA_PSS_3072_SHA256" = "RSA"
    "RSA_PSS_4096_SHA256" = "RSA"
    "RSA_PKCS1_2048_SHA256" = "RSA"
    "RSA_PKCS1_3072_SHA256" = "RSA"
    "RSA_PKCS1_4096_SHA256" = "RSA"
    "EC_P256_SHA256" = "ECDSA"
    "EC_P384_SHA384" = "ECDSA"
  }
}

variable "monitor_cert_private_key_size" {
  type = map(any)
  description = "Size of the key algorithm to be used"
  default = {
    "RSA_PSS_2048_SHA256" = "2048"
    "RSA_PSS_3072_SHA256" = "3072"
    "RSA_PSS_4096_SHA256" = "4096"
    "RSA_PKCS1_2048_SHA256" = "2048"
    "RSA_PKCS1_3072_SHA256" = "3072"
    "RSA_PKCS1_4096_SHA256" = "4096"
    "EC_P256_SHA256" = "256"
    "EC_P384_SHA384" = "384"
  }
}

variable "monitor_cert_renew_before" {
  type = string
  description = "The time when the certificates will be renewed. Format:24h50m10s"
  default = "20h"
}


variable "usages" {
  type = list(string)
  description = "List of Usages"
  default = [ "digital signature","key encipherment","server auth" ]
}

variable "digital_signature" {
  type = map(bool)
  description = "Digital signature value based on CA type"
  default = {
    "SELF_SIGNED" = true
    "SUBORDINATE" = false
  }
}

variable "key_encipherment" {
    type = map(bool)
  description = "Key encipherment value based on CA type"
  default = {
    "SELF_SIGNED" = true
    "SUBORDINATE" = false
  }
}

variable "pathlen" {
  type = number
  description = "Refers to the path length restriction X.509 extension"
  default = 0
}
