resource "aws_vpc" "main_vpc" {
  cidr_block           = var.cdr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name = var.tagtype
  }
}