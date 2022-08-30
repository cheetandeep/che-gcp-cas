## Intro
This folder contains terraform code needed to create Cetificate Authority infrastructure required to leverage Google's Certificate Authority Service (CAS). This code acts as `terrform module` that can be used to create repetable production grade CA infrastructure. 
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_privateca_ca_pool.pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/privateca_ca_pool) | resource |
| [google_privateca_certificate_authority.ca](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/privateca_certificate_authority) | resource |
| [kubernetes_manifest.certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.googlecasclusterissuer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [tls_private_key.example](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ca_name"></a> [ca\_name](#input\_ca\_name) | CA name | `string` | n/a | yes |
| <a name="input_create_k8s_configmap"></a> [create\_k8s\_configmap](#input\_create\_k8s\_configmap) | If true create a k8s configmap resource for the CA | `bool` | n/a | yes |
| <a name="input_create_k8s_issuer"></a> [create\_k8s\_issuer](#input\_create\_k8s\_issuer) | Creates a k8s GoogelCASClusterIssuer resource is set to true | `bool` | n/a | yes |
| <a name="input_digital_signature"></a> [digital\_signature](#input\_digital\_signature) | Digital signature value based on CA type | `map(bool)` | <pre>{<br>  "SELF_SIGNED": true,<br>  "SUBORDINATE": false<br>}</pre> | no |
| <a name="input_k8s_configmap_namespaces"></a> [k8s\_configmap\_namespaces](#input\_k8s\_configmap\_namespaces) | A list of namespaces to create the k8s configmap in | `list(string)` | <pre>[<br>  "hsm"<br>]</pre> | no |
| <a name="input_key_algorithm"></a> [key\_algorithm](#input\_key\_algorithm) | The algorithm to use for creating a managed Cloud KMS key for a for a simplified experience. All managed keys will be have their ProtectionLevel as HSM. Possible values are SIGN\_HASH\_ALGORITHM\_UNSPECIFIED, RSA\_PSS\_2048\_SHA256, RSA\_PSS\_3072\_SHA256, RSA\_PSS\_4096\_SHA256, RSA\_PKCS1\_2048\_SHA256, RSA\_PKCS1\_3072\_SHA256, RSA\_PKCS1\_4096\_SHA256, EC\_P256\_SHA256, and EC\_P384\_SHA384. | `string` | n/a | yes |
| <a name="input_key_encipherment"></a> [key\_encipherment](#input\_key\_encipherment) | Key encipherment value based on CA type | `map(bool)` | <pre>{<br>  "SELF_SIGNED": true,<br>  "SUBORDINATE": false<br>}</pre> | no |
| <a name="input_lifetime"></a> [lifetime](#input\_lifetime) | The desired lifetime of the CA certificate. Used to create the "notBeforeTime" and "notAfterTime" fields inside an X.509 certificate. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s" | `string` | n/a | yes |
| <a name="input_monitor_cert_duration"></a> [monitor\_cert\_duration](#input\_monitor\_cert\_duration) | The duration that the cert will be valid for. Format:24h10m67s | `string` | `"300h0m0s"` | no |
| <a name="input_monitor_cert_namespace"></a> [monitor\_cert\_namespace](#input\_monitor\_cert\_namespace) | The namespace where the certificate is created | `string` | `"nu-system"` | no |
| <a name="input_monitor_cert_private_key_algorithm"></a> [monitor\_cert\_private\_key\_algorithm](#input\_monitor\_cert\_private\_key\_algorithm) | The algorithm used for creating a managed Cloud KMS key for a simplified experience. All managed keys will have their Protection level as HSM. ossible values are SIGN\_HASH\_ALGORITHM\_UNSPECIFIED, RSA\_PSS\_2048\_SHA256, RSA\_PSS\_3072\_SHA256, RSA\_PSS\_4096\_SHA256, RSA\_PKCS1\_2048\_SHA256, RSA\_PKCS1\_3072\_SHA256, RSA\_PKCS1\_4096\_SHA256, EC\_P256\_SHA256, and EC\_P384\_SHA384 | `map(any)` | <pre>{<br>  "EC_P256_SHA256": "ECDSA",<br>  "EC_P384_SHA384": "ECDSA",<br>  "RSA_PKCS1_2048_SHA256": "RSA",<br>  "RSA_PKCS1_3072_SHA256": "RSA",<br>  "RSA_PKCS1_4096_SHA256": "RSA",<br>  "RSA_PSS_2048_SHA256": "RSA",<br>  "RSA_PSS_3072_SHA256": "RSA",<br>  "RSA_PSS_4096_SHA256": "RSA"<br>}</pre> | no |
| <a name="input_monitor_cert_private_key_size"></a> [monitor\_cert\_private\_key\_size](#input\_monitor\_cert\_private\_key\_size) | Size of the key algorithm to be used | `map(any)` | <pre>{<br>  "EC_P256_SHA256": "256",<br>  "EC_P384_SHA384": "384",<br>  "RSA_PKCS1_2048_SHA256": "2048",<br>  "RSA_PKCS1_3072_SHA256": "3072",<br>  "RSA_PKCS1_4096_SHA256": "4096",<br>  "RSA_PSS_2048_SHA256": "2048",<br>  "RSA_PSS_3072_SHA256": "3072",<br>  "RSA_PSS_4096_SHA256": "4096"<br>}</pre> | no |
| <a name="input_monitor_cert_renew_before"></a> [monitor\_cert\_renew\_before](#input\_monitor\_cert\_renew\_before) | The time when the certificates will be renewed. Format:24h50m10s | `string` | `"20h"` | no |
| <a name="input_num_ca"></a> [num\_ca](#input\_num\_ca) | The number of CAs to add to the pool | `number` | `1` | no |
| <a name="input_pathlen"></a> [pathlen](#input\_pathlen) | Refers to the path length restriction X.509 extension | `number` | `0` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project Id where the CA will be created | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Location/region of the CA | `string` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | Tier of the CA: DEVOPS or ENTERPRISE | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Type of CA either SUBORDINATE or SELF\_SIGNED(Root) | `string` | n/a | yes |
| <a name="input_usages"></a> [usages](#input\_usages) | List of Usages | `list(string)` | <pre>[<br>  "digital signature",<br>  "key encipherment",<br>  "server auth"<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->