resource "aws_s3_bucket" "vaultdb" {
  bucket        = "vault-use-cases-db"
  force_destroy = true
  tags = {
    Environment = "Terraform"
  }
}


resource "aws_s3_bucket" "ansible-logs" {
  bucket        = "vault-use-cases-logs"
  force_destroy = true
  lifecycle_rule {
    id      = "retire-old-logs"
    enabled = true

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }
  tags = {
    Environment = "Terraform"
  }
}