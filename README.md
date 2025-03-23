# Terraform-S3-bucket
I use terraform to create an S3 bucket and set up static website hosting to showcase my portfolio, projects and resumes on AWS

## Prerequisites
First we need an AWS account
Have terraform installed. Visit the officiaial Hashicorp website to find out how to do this : https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
You will need a basic understanding of Terraform (HCL syntax, variables, providers, outputs and how to connect AWS with terraform)

## Steps to Create a static website on AWS using Terraform
Start by creating an S3 bucket to store your website files. Ensure the bucket name is unique.

## Project starts here

## Define AWS provider

## Create s3 bucket
Configure the S3 bucket properties to enable the static website hosting and specify the default index document (e.g index.thml) and error documetnt (e.g error.html)

## Making Bucket Public
Allow public access to the S3 bucket and the objects by configuring the bucket policy or Access control list (ACL)

## Debugging (If you've used ACLs)
The setup is almost there, but the ACL setup is clashing with S3’s newer ownership and public access rules. S3 bucket has the "ACLs disabled" setting on — this is common with new buckets because AWS now recommends using Bucket Policies or IAM policies instead of ACLs
First, confirm your IAM user has the right permissions.
Your policy should include the S3 Administration policy. This ALLOWS all S3 permissions

As we're trying to set an ACL (e.g., acl = "public-read"), remove that line from your S3 object resource:
```
resource "aws_s3_bucket_object" "index" {
  bucket = "myterraformprojectsite2025"
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"

  # Remove the ACL line if present:
  # acl    = "public-read"
}
```
Since ACLs are off, ensure the bucket policy allows public access if that’s what you want:
```
resource "aws_s3_bucket_policy" "public_access" {
  bucket = "myterraformprojectsite2025"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "PublicReadGetObject",
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource  = "arn:aws:s3:::myterraformprojectsite2025/*"
    }]
  })
}
```


## Creating Index Html using Chatgpt
Define Objects and use AI tools to create an index.html

## Upload object in S3 using Terraform
## Enabling Static Website Hosting on s3
# Website deployed
