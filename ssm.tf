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
