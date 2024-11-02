resource "aws_s3_bucket" "redirect" {
  for_each = toset(var.subdomain_redirects)

  bucket = each.value

  tags = {
    Name   = each.value
    Module = "github.com/gwojtak/tf-module-s3-static-site"
  }
}

resource "aws_s3_bucket_public_access_block" "redirect" {
  for_each = toset(var.subdomain_redirects)

  bucket = aws_s3_bucket.redirect[each.value].id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "redirect" {
  for_each = toset(var.subdomain_redirects)

  bucket = aws_s3_bucket.redirect[each.value].id
  policy = data.aws_iam_policy_document.bucket_policy[each.value].json
}

resource "aws_s3_bucket_website_configuration" "redirect" {
  for_each = toset(var.subdomain_redirects)

  bucket = aws_s3_bucket.redirect[each.value].id

  redirect_all_requests_to {
    host_name = var.domain
    protocol  = var.redirect_to_https ? "https" : "http"
  }
}
