locals {
  cluster_name = "dotori-eks-cluster"
}

resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"

  instance_tenancy = "default"

  enable_dns_support             = true
  enable_dns_hostnames           = true

  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "main"
  }

}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "vpc id"
  sensitive   = false
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "dotori-vpc"
  cidr = "10.194.0.0/16"

  azs             = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnets  = ["10.194.0.0/24", "10.194.1.0/24"]
  private_subnets = ["10.194.100.0/24", "10.194.101.0/24"]

  enable_nat_gateway     = true
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}