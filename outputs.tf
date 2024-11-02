output "main_bucket_id" {
  description = "The ID of the created main website S3 bucket."
  value       = aws_s3_bucket.main.id
}

output "alternate_bucket_ids" {
  description = "The IDs of the created redirect S3 buckets."
  value       = { for sd in var.subdomain_redirects : sd => aws_s3_bucket.redirect[sd].id }
}

output "website_endpoint" {
  description = "The DNS name of the location of the website hosted in S3."
  value       = aws_s3_bucket_website_configuration.main.website_endpoint
}

output "redirect_website_endpoints" {
  description = "The DNS names of the locations of the redirect buckets."
  value       = { for sd in var.subdomain_redirects : sd => aws_s3_bucket_website_configuration.redirect[sd].website_endpoint }
}
