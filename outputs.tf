output "primary_s3_bucket" {
  description = "The object of the main S3 bucket created."
  value       = aws_s3_bucket.main
}

output "redirect_s3_bucket" {
  description = "The objects for any created redirect buckets."
  value       = [for bucket in aws_s3_bucket.redirect : bucket]
}

output "bucket_policies" {
  description = "The policies attached to each bucket."
  value = concat(
    [aws_s3_bucket_policy.main],
    [for pol in aws_s3_bucket_policy.redirect : pol]
  )
}

output "cloudfront_distribution" {
  description = "Cloudfront distribution object created in the module."
  value       = local.cloudfront_enabled ? aws_cloudfront_distribution.cdn["cdn"] : null
}
