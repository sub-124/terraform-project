#creation of the s3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname

}

#creation of the s3 bucket ID
output "mybucket_id" {
  value = aws_s3_bucket.mybucket.id
}

#creating the bucket ownership
resource "aws_s3_bucket_ownership_controls" "ownership1" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket-public" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket-acl-public" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership1,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"

  depends_on = [ aws_s3_bucket_acl.bucket-acl-public, ]
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"

  depends_on = [ aws_s3_bucket_acl.bucket-acl-public, ]
}

resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.bucket-acl-public, ]

}

# Dynamic output for S3 website endpoint
data "aws_region" "current" {}

output "s3_website_endpoint" {
  value = "http://${aws_s3_bucket.mybucket.bucket}.s3-website-${data.aws_region.current.name}.amazonaws.com"
}