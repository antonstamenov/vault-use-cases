resource "aws_instance" "vault-node" {
  count                  = 1
  ami                    = data.aws_ami.amazon-linux-2.image_id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnets[0]
  key_name               = "helecloud"
  iam_instance_profile   = aws_iam_instance_profile.vault-nodes.name
  vpc_security_group_ids = [aws_security_group.vault-nodes.id]
  tags = {
    "Name"         = "vault-node${count.index}"
    "VaultCluster" = "vault-use-cases"
    "Environment"  = "poc"
  }
  depends_on = [aws_security_group.vault-nodes]
}

resource "aws_security_group" "vault-nodes" {
  name   = "vault-nodes"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "vault-nodes-egress" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vault-nodes.id
  type              = "egress"
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}