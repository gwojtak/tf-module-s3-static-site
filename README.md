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
| [aws_cloudfront_distribution.cdn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.oai](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
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
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | If `cdn_provider` is `CLOUDFRONT`, set the value of the ACM certificate here. | `string` | `null` | no |
| <a name="input_cdn_provider"></a> [cdn\_provider](#input\_cdn\_provider) | Set a CDN provider to use.  Valid values are `NONE` and `CLOUDFRONT`. | `string` | `"NONE"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The name of the domain the website is to be located at. | `string` | n/a | yes |
| <a name="input_error_document"></a> [error\_document](#input\_error\_document) | Set this to an S3 key that should be used for 4xx status code errors. | `string` | `""` | no |
| <a name="input_index_document"></a> [index\_document](#input\_index\_document) | Sets the index document for the site.  Should be a full path within the S3 bucket. | `string` | `"index.html"` | no |
| <a name="input_redirect_to_https"></a> [redirect\_to\_https](#input\_redirect\_to\_https) | Controls whether any redirect buckets should use https or http. | `bool` | `true` | no |
| <a name="input_subdomain_redirects"></a> [subdomain\_redirects](#input\_subdomain\_redirects) | A list of subdomains to set up as redirects to the main domain (e.g., `www`). | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_policies"></a> [bucket\_policies](#output\_bucket\_policies) | The policies attached to each bucket. |
| <a name="output_cloudfront_distribution"></a> [cloudfront\_distribution](#output\_cloudfront\_distribution) | Cloudfront distribution object created in the module. |
| <a name="output_primary_s3_bucket"></a> [primary\_s3\_bucket](#output\_primary\_s3\_bucket) | The object of the main S3 bucket created. |
| <a name="output_redirect_s3_bucket"></a> [redirect\_s3\_bucket](#output\_redirect\_s3\_bucket) | The objects for any created redirect buckets. |
