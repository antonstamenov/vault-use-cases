resource "aws_s3_bucket" "artifacts" {
  bucket = "vault-use-cases-artifacts"

  versioning {
    enabled = true
  }

  force_destroy = true

  lifecycle_rule {
    id      = "retire-old-versions"
    enabled = false
    noncurrent_version_transition {
      days          = 30
      storage_class = "GLACIER"
    }
    noncurrent_version_expiration {
      days = 90
    }
  }

  tags = {
    Environment = "Terraform"
  }
}