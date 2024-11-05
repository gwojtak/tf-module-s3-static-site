/*
 * # tf-module-s3-static-site
 * Creates an S3 bucket configured to host a static website, as well as
 * optional redirect buckets, for example if you want www.mysite.com to
 * redirect to mysite.com.
 *
 * ## Basic Usage
 * ```hcl
 * module "site" {
 *   source = "github.com/gwojtak/tf-module-s3-static-site"
 *
 * module "static_site" {
 *   source = "../../tf-module-s3-static-site"
 *
 *   domain              = "mystaticsite.com"
 *   error_document      = "index.html"
 *   subdomain_redirects = ["www"]
 * }
 * ```
 */
locals {
  all_bucket_names = concat([var.domain], var.subdomain_redirects)
  bucket_arns = merge(
    {
      (var.domain) = aws_s3_bucket.main.arn
    },
    {
      for dom in var.subdomain_redirects : dom => aws_s3_bucket.redirect[dom].arn
    }
  )
  cloudfront_enabled = var.cdn_provider == "CLOUDFRONT"
  policy_principals = {
    type        = var.cdn_provider == "CLOUDFRONT" ? "AWS" : "*"
    identifiers = var.cdn_provider == "CLOUDFRONT" ? [aws_cloudfront_origin_access_identity.oai["cdn"].iam_arn] : ["*"]
  }
}

data "aws_iam_policy_document" "bucket_policy" {
  for_each = toset(local.all_bucket_names)

  statement {
    sid       = "S3${each.value}StaticWebsiteAccess"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${local.bucket_arns[each.value]}/*"]

    principals {
      type        = local.policy_principals["type"]
      identifiers = local.policy_principals["identifiers"]
    }
  }
}

resource "aws_s3_bucket" "main" {
  bucket = var.domain

  tags = {
    Name   = var.domain
    Module = "github.com/gwojtak/tf-module-s3-static-site"
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = local.cloudfront_enabled
  block_public_policy     = local.cloudfront_enabled
  ignore_public_acls      = local.cloudfront_enabled
  restrict_public_buckets = local.cloudfront_enabled
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.bucket_policy[var.domain].json

  depends_on = [aws_s3_bucket_public_access_block.main]
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "main" {
  for_each = local.cloudfront_enabled ? toset([]) : toset([var.domain])

  bucket = aws_s3_bucket.main.id

  index_document {
    suffix = var.index_document
  }

  dynamic "error_document" {
    for_each = toset([var.error_document])

    content {
      key = error_document.value
    }
  }
}
