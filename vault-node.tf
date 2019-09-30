resource "aws_autoscaling_group" "vault-cluster" {
  name                 = "vault-cluster"
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  launch_configuration = aws_launch_configuration.vault-nodes.name
}


resource "aws_launch_configuration" "vault-nodes" {
  image_id             = data.aws_ami.amazon-linux-2.id
  instance_type        = "t2.micro"
  key_name             = "helecloud"
  name_prefix          = "vault-node-"
  iam_instance_profile = aws_iam_instance_profile.vault-nodes.name
  security_groups      = [aws_security_group.vault-nodes.name]
  tags = {
    "VaultCluster" = "vault-use-cases"
    "Environment"  = "poc"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "vault-nodes" {
  name = "vault-nodes"
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = [
  "amazon"]

  filter {
    name = "name"
    values = [
    "amzn2-ami-hvm-2.0.*"]
  }

  filter {
    name = "architecture"
    values = [
    "x86_64"]
  }

  filter {
    name = "virtualization-type"
    values = [
    "hvm"]
  }
}