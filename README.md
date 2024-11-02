# tf-module-s3-static-site
Creates an S3 bucket configured to host a static website, as well as
optional redirect buckets, for example if you want www.mysite.com to
redirect to mysite.com.

## Basic Usage
```hcl
module "site" {
  source = "github.com/gwojtak/tf-module-s3-static-site"

module "static_site" {
  source = "../../tf-module-s3-static-site"

  domain              = "mystaticsite.com"
  error_document      = "index.html"
  subdomain_redirects = ["www"]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_s3_bucket_website_configuration.redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain"></a> [domain](#input\_domain) | The name of the domain the website is to be located at. | `string` | n/a | yes |
| <a name="input_error_document"></a> [error\_document](#input\_error\_document) | Set this to an S3 key that should be used for 4xx status code errors. | `string` | `""` | no |
| <a name="input_index_document"></a> [index\_document](#input\_index\_document) | Sets the index document for the site.  Should be a full path within the S3 bucket. | `string` | `"index.html"` | no |
| <a name="input_redirect_to_https"></a> [redirect\_to\_https](#input\_redirect\_to\_https) | Controls whether any redirect buckets should use https or http. | `bool` | `true` | no |
| <a name="input_subdomain_redirects"></a> [subdomain\_redirects](#input\_subdomain\_redirects) | A list of subdomains to set up as redirects to the main domain (e.g., `www`). | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alternate_bucket_ids"></a> [alternate\_bucket\_ids](#output\_alternate\_bucket\_ids) | The IDs of the created redirect S3 buckets. |
| <a name="output_main_bucket_id"></a> [main\_bucket\_id](#output\_main\_bucket\_id) | The ID of the created main website S3 bucket. |
| <a name="output_redirect_website_endpoints"></a> [redirect\_website\_endpoints](#output\_redirect\_website\_endpoints) | The DNS names of the locations of the redirect buckets. |
| <a name="output_website_endpoint"></a> [website\_endpoint](#output\_website\_endpoint) | The DNS name of the location of the website hosted in S3. |
