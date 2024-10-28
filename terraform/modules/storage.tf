# Content-Type list
locals {
  content_types = {
    css  = "text/css"
    html = "text/html"
    js   = "application/javascript"
    json = "application/json"
    txt  = "text/plain"
    png  = "image/png"
    jpg  = "image/jpeg"
  }
}

resource "aws_s3_bucket" "s3_staticsite" {
  bucket = var.bucketname
  tags = var.bucket_tags
}

# Enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "s3_staticsite_versioning" {
  bucket = aws_s3_bucket.s3_staticsite.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

# Upload folders and subfolders to the S3 bucket
resource "aws_s3_object" "folder_files" {
  for_each = fileset("${var.html_path}", "**")

  bucket = aws_s3_bucket.s3_staticsite.id
  key    = each.value
  source = "${var.html_path}${each.value}" 

  etag = filemd5("${var.html_path}${each.value}")

  # Set Content-Type based on the local.content_type
  content_type = lookup(local.content_types, split(".", each.value)[1], "text/html")
}

# Add a bucket policy for public read access to the objects from the cloudfront distribution
resource "aws_s3_bucket_policy" "s3_staticsite_public_acl" {
  bucket = aws_s3_bucket.s3_staticsite.id
  policy = data.aws_iam_policy_document.cloudfront_oac.json
}
