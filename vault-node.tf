resource "aws_instance" "vault-node" {
  count                = 2
  ami                  = data.aws_ami.amazon-linux-2.id
  instance_type        = "t2.micro"
  subnet_id            = module.vpc.private_subnets[0]
  key_name             = "helecloud"
  iam_instance_profile = aws_iam_instance_profile.vault-nodes.name

  tags = {
    "Name"          = "vault-node${count.index}"
    "vault-cluster" = "vault-use-cases"
  }

  user_data_base64 = data.template_cloudinit_config.vault-nodes.rendered
}

resource "aws_security_group" "vault-nodes" {
  name = "vault-nodes"
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