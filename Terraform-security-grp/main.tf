resource "aws_security_group" "main_sg" {
  name        = "${var.tagtype}-sg"
  description = "${var.tagtype} security grp"
  vpc_id      = var.vpc_id
  dynamic ingress {
    for_each =var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cdr
    }   
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.egresscdr]
  }
  tags = {
    name = var.tagtype
  }

}