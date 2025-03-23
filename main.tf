resource "aws_s3_bucket" "myfirstbucket" {
  bucket = var.bucketname
}

# Ensure ownership control is set
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.myfirstbucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Disable public access restrictions
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.myfirstbucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Define public read bucket policy
resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.myfirstbucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.myfirstbucket.arn}/*"
      }
    ]
  })
}

# Set the ACL to public-read
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example
  ]

  bucket = aws_s3_bucket.myfirstbucket.id
  acl    = "public-read"
}

# Upload index.html
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.myfirstbucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}

# Upload error.html
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.myfirstbucket.id
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"
}

# Upload profile image
resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.myfirstbucket.id
  key    = "profile.png"
  source = "profile.png"
  etag   = filemd5("profile.png")
}

# Configure website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.myfirstbucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}