resource "aws_subnet" "main_public_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cdr
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = var.az
  tags= var.tags
}