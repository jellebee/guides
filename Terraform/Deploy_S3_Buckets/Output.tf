
output "s3_bucket" {
  value = aws_s3_bucket.mybucket.bucket
}
output "s3_loggingbucket" {
  value = aws_s3_bucket.mylogsbucket.id
}
output "BucketDomain" {
  value = aws_s3_bucket.mybucket.bucket_regional_domain_name
}
/*
output "s3bucket_acl" {
  value = aws_s3_bucket.mybucket.acl
}
output "s3_website_domain" {
  value = aws_s3_bucket.mybucket.website_domain
}
output "s3_website_endpoint" {
  value = aws_s3_bucket.mybucket.website_endpoint
}
*/