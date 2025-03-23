output "website_endpoint" {
    value = aws_s3_bucket.myfirstbucket.bucket_regional_domain_name
}