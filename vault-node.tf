resource "aws_autoscaling_group" "vault-cluster" {
  name             = "vault-cluster"
  desired_capacity = 1
  max_size         = 2
  min_size         = 1
  launch_template {
    id      = aws_launch_template.vault-nodes.id
    version = "$Latest"
  }

  target_group_arns   = [aws_lb_target_group.vault-nodes.arn]
  vpc_zone_identifier = module.vpc.private_subnets

  health_check_type = "EC2"

  tags = [
    {
      key                 = "VaultCluster"
      value               = "vault-use-cases"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "poc"
      propagate_at_launch = true
    }
  ]
}

resource "aws_lb_target_group" "vault-nodes" {
  name     = "vault-cluster"
  port     = 8200
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  health_check {
    path     = "/status"
    protocol = "HTTPS"
  }
}

resource "aws_launch_template" "vault-nodes" {
  image_id             = data.aws_ami.amazon-linux-2.id
  instance_type        = "t2.micro"
  key_name             = "helecloud"
  name_prefix          = "vault-node-"
  iam_instance_profile = aws_iam_instance_profile.vault-nodes.name
  security_groups = [
  aws_security_group.vault-nodes.name]

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