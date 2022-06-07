module "main_vpc" {
  source               = "./Terraform-aws-vpc"
  cdr                  = var.cdr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tagtype              = var.tagtype
}

module "security_grp" {
  source        = "./Terraform-security-grp"
  tagtype       = var.tagtype
  vpc_id        = module.main_vpc.vpc_id
  ingress_rules = var.ingress_rules
  egresscdr     = var.egresscdr
}

resource "aws_subnet" "main_public_subnet" {
  vpc_id                  = module.main_vpc.vpc_id
  cidr_block              = "10.121.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-1a"
  tags = {
    Name = "dev-public"
  }
}
resource "aws_internet_gateway" "main_internet_gtw" {
  vpc_id = module.main_vpc.vpc_id
  tags = {
    Name = "dev-gtw"
  }
}
resource "aws_route_table" "main_rt" {
  vpc_id = module.main_vpc.vpc_id

  tags = {
    Name = "dev-public-rt"
  }
}
resource "aws_route" "default_r" {
  route_table_id         = aws_route_table.main_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_internet_gtw.id
}
resource "aws_route_table_association" "main_public_associate" {
  subnet_id      = aws_subnet.main_public_subnet.id
  route_table_id = aws_route_table.main_rt.id
}

resource "aws_key_pair" "main_auth" {
  key_name   = "mainkey"
  public_key = file("~/.ssh/main_key.pub")
}
module "main_node" {
  source                  = "./Terraform-aws-ec2"
  ami                     = data.aws_ami.main_ami.id                                     //
  instance_type           = var.instance_type                                            //
  az                      = var.startaz                                                  //
  cpu_core_count          = var.instance_type != "t2.micro" ? var.cpu_core_count : null  //
  cpu_threads_per_core    = var.cpu_core_count != null ? var.cpu_threads_per_core : null //
  key_name                = aws_key_pair.main_auth.id                                    //
  monitoring              = var.monitoring                                               //
  subnet_id               = aws_subnet.main_public_subnet.id                             //
  vpc_security_group_ids  = [module.security_grp.sg_id]                                  //
  path                    = "./userdata.tpl"                                             //
  name                    = var.tagtype                                                  //
  instance_count          = var.instance_count                                           // 
  host_os                 = var.host_os                                                  //  
  enclave_options_enabled = var.cpu_core_count >= 2 ? var.enclave_options_enabled : null
  timeouts                = var.timeouts
  tags = { //
    Terraform   = "true"
    Environment = "dev"
  }
}