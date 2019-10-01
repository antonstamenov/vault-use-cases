resource "aws_iam_instance_profile" "vault-nodes" {
  name = "vote-nodes"
  role = aws_iam_role.ssm-ssh-proxy.name
}

resource "aws_iam_role" "ssm-ssh-proxy" {
  name               = "ssm-ssh-proxy"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
}

data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ssm-ssh-proxy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.ssm-ssh-proxy.name
}


data "aws_iam_policy_document" "vault-s3-backend" {
  statement {
    sid       = "VaultS3backend"
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.vaultdb.arn}/*", "${aws_s3_bucket.vaultdb.arn}"]
  }
}

resource "aws_iam_policy" "vault-s3-backend" {
  name   = "vault-s3-backend"
  policy = data.aws_iam_policy_document.vault-s3-backend.json
}

resource "aws_iam_role_policy_attachment" "vault-s3-backend" {
  policy_arn = aws_iam_policy.vault-s3-backend.arn
  role       = aws_iam_role.ssm-ssh-proxy.name
}