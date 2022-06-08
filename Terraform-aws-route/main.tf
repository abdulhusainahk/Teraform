resource "aws_internet_gateway" "main_internet_gtw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.tag}-gtw"
  }
}
resource "aws_route_table" "main_rt" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.tag}-public-rt"
  }
}
resource "aws_route" "default_r" {
  route_table_id         = aws_route_table.main_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_internet_gtw.id
}
resource "aws_route_table_association" "main_public_associate" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.main_rt.id
}