module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.15.0"

  name = "vault-use-cases"

  cidr = "10.20.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  public_subnets  = ["10.20.101.0/24", "10.20.102.0/24"]
  private_subnets = ["10.20.1.0/24", "10.20.2.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_vpn_gateway = true

  # This is required by private endpoint for EKS
  enable_dns_hostnames     = true
  enable_dns_support       = true
  enable_dhcp_options      = true
  dhcp_options_domain_name = "AmazonProvidedDNS"

  tags = {
    Terraform   = "true"
    Environment = "poc"
  }
}

