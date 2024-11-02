# locals {
#   cf_alias_arg = {
#     for dom in var.subdomain_redirects :
#     dom => aws_s3_bucket_website_configuration.redirect[dom].website_domain
#   }
# }

# module "cf_site" {
#   for_each = var.cdn_provider == "CLOUDFLARE" ? toset([var.domain]) : toset([])
#
#   source = "../tf-module-cloudflare-site"
#
#   aliases       = local.cf_alias_arg
#   domain        = var.domain
#   target_domain = aws_s3_bucket_website_configuration.main.website_domain
# }
